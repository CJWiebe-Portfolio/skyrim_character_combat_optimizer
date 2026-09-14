/**
 * =========================================================
 * FILE: app.js
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: C.J. Wiebe
 * =========================================================
 * DESCRIPTION:
 * The shared front-end layer for the static build of the site.
 * It replaces what PHP used to do on the server:
 *
 *   database.php            -> Firebase init + Firestore helpers (below)
 *   session_start / $_SESSION -> Firebase Auth session (onAuthStateChanged)
 *   header.php / navbar.php / footer.php -> renderChrome() below
 *   BASE_URL                -> window.SITE_ROOT, set by each page
 *
 * Every page imports this module.
 * =========================================================
 */

import { initializeApp } from "https://www.gstatic.com/firebasejs/11.6.0/firebase-app.js";
import {
  getAuth,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  updatePassword,
  verifyBeforeUpdateEmail,
  sendPasswordResetEmail,
  sendEmailVerification,
  deleteUser,
  EmailAuthProvider,
  reauthenticateWithCredential
} from "https://www.gstatic.com/firebasejs/11.6.0/firebase-auth.js";
import {
  getFirestore,
  doc,
  getDoc,
  setDoc,
  updateDoc,
  deleteDoc,
  collection,
  getDocs,
  addDoc,
  query,
  orderBy,
  serverTimestamp,
  increment,
  writeBatch
} from "https://www.gstatic.com/firebasejs/11.6.0/firebase-firestore.js";

import { firebaseConfig } from "./firebase-config.js";

/* =========================================================
   FIREBASE INITIALISATION
   ========================================================= */

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);

/** True while firebase-config.js still holds the placeholder values. */
export const CONFIG_IS_PLACEHOLDER =
  String(firebaseConfig.apiKey || "").startsWith("PASTE_YOUR");

/* =========================================================
   PATHS
   Each page sets window.SITE_ROOT before importing this file
   ("./" at the repo root, "../" one folder deep). That keeps
   every link correct on GitHub Pages, where the site lives
   under /<repo-name>/ rather than at the domain root.
   ========================================================= */

export const ROOT = window.SITE_ROOT || "./";
export const url = (p) => ROOT + p.replace(/^\/+/, "");

/* =========================================================
   STATIC REFERENCE DATA (was the item / category / perk tables)
   ========================================================= */

let _data = null;

/** Loads assets/data/items.json once and caches it. */
export async function refData() {
  if (_data) return _data;
  const res = await fetch(url("assets/data/items.json"));
  if (!res.ok) throw new Error("Could not load items.json (" + res.status + ")");
  _data = await res.json();
  return _data;
}

/**
 * The PHP pages overrode weapon speed at render time based on category.
 * Same rule, same numbers.
 */
export function effectiveSpeed(item, data) {
  const override = data.speedByCategory[String(item.category_id)];
  return override !== undefined ? override : item.speed;
}

/** weight was decimal(6,2) in MySQL, so keep two decimal places. */
export function fmtWeight(v) {
  return v === null || v === undefined ? null : Number(v).toFixed(2);
}

/** Weapon speeds read as 1.0 / 0.9 / 0.7 in the original tables. */
export function fmtSpeed(v) {
  return v === null || v === undefined ? null : Number(v).toFixed(1);
}

/* =========================================================
   AUTH  (replaces login.php / logout.php / $_SESSION)
   ========================================================= */

/** Resolves with the current user, or null, once Firebase has decided. */
export function currentUser() {
  return new Promise((resolve) => {
    const stop = onAuthStateChanged(auth, (user) => {
      stop();
      resolve(user);
    });
  });
}

/**
 * Stops the rest of a page module from running, without throwing.
 * Used after a redirect or a fatal "not found", where the PHP pages called exit().
 */
export function halt() {
  return new Promise(() => {});
}

/**
 * Page guard: the equivalent of the PHP
 *   if (!isset($_SESSION['email'])) { header("Location: login.php"); exit(); }
 * Returns the signed-in user, or redirects to the login page.
 */
export async function requireAuth() {
  const user = await currentUser();
  if (!user) {
    window.location.href = url("login/login.html");
    await halt();
  }
  return user;
}

export const login = (email, password) =>
  signInWithEmailAndPassword(auth, email, password);

export const logout = () => signOut(auth);

/**
 * Creates the Auth user, their profile document, and sends a verification email.
 *
 * If the profile write is rejected (almost always: the Firestore rules in
 * firestore.rules have not been published), the new Auth user is rolled back,
 * so you don't end up with an account that can sign in but has no data and
 * cannot be registered again.
 */
export async function signup({ firstName, lastName, email, password, dob }) {
  const cred = await createUserWithEmailAndPassword(auth, email, password);

  try {
    await setDoc(doc(db, "users", cred.user.uid), {
      firstName,
      lastName,
      email,
      dob: dob || "",
      role: "user",
      createdAt: serverTimestamp()
    });
  } catch (err) {
    try {
      await deleteUser(cred.user);
    } catch {
      // Rollback failed; the caller still sees the original error below.
    }
    throw err;
  }

  // Best effort: a failed verification email must not fail the registration.
  try {
    await sendEmailVerification(cred.user);
  } catch (e) {
    console.warn("Could not send verification email:", e);
  }

  return cred.user;
}

/** Re-sends the "confirm your address" email. */
export function sendVerification(user) {
  return sendEmailVerification(user);
}

/** Sends a password reset link. Used by the Forgot password form on the login page. */
export function resetPassword(email) {
  return sendPasswordResetEmail(auth, email);
}

/**
 * Changes the account email.
 *
 * Firebase BLOCKS the old updateEmail() on every project created after
 * 15 September 2023, because email enumeration protection is on by default.
 * The supported route is verifyBeforeUpdateEmail: Firebase mails the NEW
 * address, and the change only lands once that link is clicked. So the address
 * does not change the moment this resolves — say so in the UI.
 */
export function changeEmail(user, newEmail) {
  return verifyBeforeUpdateEmail(user, newEmail);
}

/** Firebase requires a recent login before email/password/account changes. */
export function reauth(user, password) {
  const cred = EmailAuthProvider.credential(user.email, password);
  return reauthenticateWithCredential(user, cred);
}

export { updatePassword, deleteUser };

/* =========================================================
   PROFILE  (was the `accounts` table)
   users/{uid}
   ========================================================= */

export async function getProfile(uid) {
  const snap = await getDoc(doc(db, "users", uid));
  return snap.exists() ? snap.data() : null;
}

/**
 * Returns the profile, creating a minimal one if it is missing.
 *
 * A profile can be missing if the account was registered while the Firestore
 * rules were still denying writes. Rather than showing a blank account page
 * forever, seed it from what Auth knows and let the user correct it.
 */
export async function ensureProfile(user) {
  const existing = await getProfile(user.uid);
  if (existing) return existing;

  const seeded = {
    firstName: (user.email || "").split("@")[0] || "Adventurer",
    lastName: "",
    email: user.email || "",
    dob: "",
    role: "user",
    createdAt: serverTimestamp()
  };
  await setDoc(doc(db, "users", user.uid), seeded, { merge: true });
  return seeded;
}

export function saveProfile(uid, fields) {
  return setDoc(doc(db, "users", uid), fields, { merge: true });
}

export function deleteProfileDoc(uid) {
  return deleteDoc(doc(db, "users", uid));
}

/* =========================================================
   CHARACTERS  (was the `character` table)
   users/{uid}/characters/{characterId}
   ========================================================= */

const charsCol = (uid) => collection(db, "users", uid, "characters");
const charDoc = (uid, cid) => doc(db, "users", uid, "characters", cid);

export async function listCharacters(uid) {
  const snap = await getDocs(query(charsCol(uid), orderBy("characterNumber")));
  return snap.docs.map((d) => ({ id: d.id, ...d.data() }));
}

export async function getCharacter(uid, cid) {
  const snap = await getDoc(charDoc(uid, cid));
  return snap.exists() ? { id: snap.id, ...snap.data() } : null;
}

/** Mirrors the PHP "MAX(character_number) + 1 per account" logic. */
export async function createCharacter(uid, { name, raceId }) {
  const existing = await listCharacters(uid);
  const next = existing.reduce((m, c) => Math.max(m, c.characterNumber || 0), 0) + 1;
  // Seed the build from the race, exactly as character creation does in game.
  let build = {};
  try {
    const bd = await buildData();
    build = {
      skills: startingSkills(raceId, bd),
      perks: {},
      attributePicks: { health: 0, magicka: 0, stamina: 0 }
    };
  } catch (e) {
    console.warn("Could not seed starting skills:", e);
  }

  const ref = await addDoc(charsCol(uid), {
    name,
    raceId: Number(raceId),
    characterNumber: next,
    ...build,
    createdAt: serverTimestamp()
  });
  return ref.id;
}

/** Saves the skills / perks / attribute allocation for one character. */
export function saveBuild(uid, cid, { skills, perks, attributePicks }) {
  return updateDoc(charDoc(uid, cid), { skills, perks, attributePicks });
}

/**
 * Fills in a build for a character saved before these fields existed, so older
 * characters open with their race's starting spread rather than blank.
 */
export function withDefaultBuild(character, bd) {
  return {
    ...character,
    skills: character.skills && Object.keys(character.skills).length
      ? character.skills
      : startingSkills(character.raceId, bd),
    perks: character.perks || {},
    attributePicks: character.attributePicks || { health: 0, magicka: 0, stamina: 0 }
  };
}

export function updateCharacter(uid, cid, { name, raceId }) {
  return updateDoc(charDoc(uid, cid), { name, raceId: Number(raceId) });
}

/** Deletes the character and every inventory and spellbook row underneath it. */
export async function deleteCharacter(uid, cid) {
  const [inv, spells] = await Promise.all([
    getDocs(collection(db, "users", uid, "characters", cid, "inventory")),
    getDocs(collection(db, "users", uid, "characters", cid, "spellbook"))
  ]);
  const batch = writeBatch(db);
  inv.docs.forEach((d) => batch.delete(d.ref));
  spells.docs.forEach((d) => batch.delete(d.ref));
  batch.delete(charDoc(uid, cid));
  await batch.commit();
}

/* =========================================================
   INVENTORY  (was the `inventory_item` table)
   users/{uid}/characters/{characterId}/inventory/{itemId}
   The item id is the document id, so "one row per item per
   character" is enforced by the data model itself.
   ========================================================= */

const invCol = (uid, cid) => collection(db, "users", uid, "characters", cid, "inventory");
const invDoc = (uid, cid, itemId) =>
  doc(db, "users", uid, "characters", cid, "inventory", String(itemId));

export async function listInventory(uid, cid) {
  const snap = await getDocs(invCol(uid, cid));
  return snap.docs.map((d) => ({ itemId: Number(d.id), ...d.data() }));
}

/** Adds to an existing row or creates it — the PHP upsert. */
export async function addInventoryItem(uid, cid, itemId, qty) {
  const ref = invDoc(uid, cid, itemId);
  const snap = await getDoc(ref);
  if (snap.exists()) {
    await updateDoc(ref, { quantity: increment(Number(qty)) });
  } else {
    await setDoc(ref, { itemId: Number(itemId), quantity: Number(qty) });
  }
}

export function increaseInventoryItem(uid, cid, itemId) {
  return updateDoc(invDoc(uid, cid, itemId), { quantity: increment(1) });
}

/** Drops the row entirely when the count would reach zero. */
export async function decreaseInventoryItem(uid, cid, itemId) {
  const ref = invDoc(uid, cid, itemId);
  const snap = await getDoc(ref);
  if (!snap.exists()) return;
  if ((snap.data().quantity || 0) > 1) {
    await updateDoc(ref, { quantity: increment(-1) });
  } else {
    await deleteDoc(ref);
  }
}

export function deleteInventoryItem(uid, cid, itemId) {
  return deleteDoc(invDoc(uid, cid, itemId));
}

/* =========================================================
   SPELLBOOK
   users/{uid}/characters/{characterId}/spellbook/{spellId}
   Same shape as inventory, but a spell is either known or not —
   there is no quantity, so the document id alone carries the fact.
   ========================================================= */

const spellCol = (uid, cid) => collection(db, "users", uid, "characters", cid, "spellbook");
const spellDoc = (uid, cid, spellId) =>
  doc(db, "users", uid, "characters", cid, "spellbook", String(spellId));

export async function listSpellbook(uid, cid) {
  const snap = await getDocs(spellCol(uid, cid));
  return snap.docs.map((d) => d.id);
}

export function learnSpell(uid, cid, spellId) {
  return setDoc(spellDoc(uid, cid, spellId), { spellId: String(spellId) });
}

export function forgetSpell(uid, cid, spellId) {
  return deleteDoc(spellDoc(uid, cid, spellId));
}

/** Learns several at once — used by "learn every spell in this school". */
export async function learnSpells(uid, cid, spellIds) {
  const batch = writeBatch(db);
  spellIds.forEach((sid) => batch.set(spellDoc(uid, cid, sid), { spellId: String(sid) }));
  await batch.commit();
}

export async function forgetSpells(uid, cid, spellIds) {
  const batch = writeBatch(db);
  spellIds.forEach((sid) => batch.delete(spellDoc(uid, cid, sid)));
  await batch.commit();
}

/* =========================================================
   PAGE CHROME  (was header.php / navbar.php / footer.php)
   ========================================================= */

const esc = (s) =>
  String(s ?? "").replace(/[&<>"']/g, (c) =>
    ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c])
  );
export { esc };

function navbarHTML(user, profile, active) {
  const is = (name) => (active === name ? "active" : "");
  const signedIn = !!user;
  const displayName = profile?.firstName || user?.email || "Account";

  return `
  <nav class="navbar navbar-expand-lg skyrim-navbar shadow-soft sticky-top">
    <div class="container">

      <a class="navbar-brand d-flex align-items-center gap-2 font-title" href="${url("home.html")}">
        <img src="${url("assets/images/skyrim_icon.png")}" alt="Skyrim Logo" width="40" height="40"
             class="d-inline-block align-text-middle">Skyrim Character Combat Optimizer</a>

      <button class="navbar-toggler skyrim-toggler" type="button"
              data-bs-toggle="collapse" data-bs-target="#navbarNav"
              aria-controls="navbarNav" aria-expanded="false"
              aria-label="Toggle navigation menu">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto gap-lg-2">

          <li class="nav-item">
            <a class="nav-link nav-btn ${is("home")}" href="${url("home.html")}">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-btn ${is("items")}" href="${url("general_information/all_items.html")}">All Items</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-btn ${is("references")}" href="${url("references.html")}">References</a>
          </li>

          ${
            signedIn
              ? `
          <li class="nav-item">
            <a class="nav-link nav-btn ${is("characters")}" href="${url("my_character/characters.html")}">My Characters</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link nav-btn dropdown-toggle" href="#" data-bs-toggle="dropdown">${esc(displayName)}</a>
            <ul class="dropdown-menu dropdown-menu-end skyrim-dropdown">
              <li><a class="dropdown-item" href="${url("my_account/read_account.html")}">My Account</a></li>
              <li><a class="dropdown-item" href="#" data-action="logout">Logout</a></li>
            </ul>
          </li>`
              : `
          <li class="nav-item">
            <a class="nav-link nav-btn" href="${url("login/create_account.html")}">Create Account</a>
          </li>
          <li class="nav-item">
            <a class="nav-link nav-btn nav-btn-primary" href="${url("login/login.html")}">Login</a>
          </li>`
          }

        </ul>
      </div>
    </div>
  </nav>`;
}

function footerHTML() {
  const now = new Date();
  const build = now.toISOString().slice(0, 10);
  return `
  <footer class="site-footer mt-auto py-4">
    <div class="container">
      <div class="row text-center text-md-start">

        <div class="col-md-4 mb-3">
          <h5 class="fw-bold text-lg">Skyrim Character Combat Optimizer</h5>
          <p class="small mb-0 text-m">
            Combat Optimization System for analyzing builds, gear, and efficiency.
          </p>
        </div>

        <div class="col-md-4 mb-3">
          <h6 class="fw-bold text-lg">Navigation</h6>
          <ul class="list-unstyled text-m">
            <li><a href="${url("home.html")}">Home</a></li>
            <li><a href="${url("references.html")}">References</a></li>
          </ul>
        </div>

        <div class="col-md-4 mb-3">
          <h6 class="fw-bold text-lg">About</h6>
          <p class="small mb-0 text-m">C. J. Wiebe</p>

          <!-- External links: NOT wrapped in url(). That helper prefixes the site
               root for internal pages and would mangle a full URL. -->
          <ul class="footer-links list-unstyled text-m">
            <li>
              <a href="https://projects.cjpwiebe-portfolio.ca/" target="_blank" rel="noopener">
                Portfolio
              </a>
            </li>
            <li>
              <a href="https://github.com/CJWiebe-Portfolio" target="_blank" rel="noopener">
                GitHub
              </a>
            </li>
            <li>
              <a href="https://www.linkedin.com/in/cygnus-j-wiebe" target="_blank" rel="noopener">
                LinkedIn
              </a>
            </li>
            <li>
              <a href="https://www.instagram.com/c.j.wiebe/" target="_blank" rel="noopener">
                Instagram
              </a>
            </li>
          </ul>
        </div>

      </div>

      <hr class="border-light">

      <div class="text-center text-lg">
        ${now.getFullYear()} - Skyrim Character Combat Optimizer
        <p class="small">Version 1.0 &middot; Build ${build}</p>
      </div>
    </div>
  </footer>`;
}

/**
 * Renders the navbar and footer into #navbar-slot / #footer-slot, and warns
 * loudly if firebase-config.js has not been filled in yet.
 * Returns { user, profile } so pages can carry on without a second lookup.
 */
export async function renderChrome(activePage) {
  const user = await currentUser();
  let profile = null;
  if (user) {
    try {
      profile = await ensureProfile(user);
    } catch (e) {
      console.warn("Could not load profile:", e);
      if (e?.code === "permission-denied") showRulesWarning();
    }
  }

  const nav = document.getElementById("navbar-slot");
  if (nav) nav.innerHTML = navbarHTML(user, profile, activePage);

  const foot = document.getElementById("footer-slot");
  if (foot) foot.innerHTML = footerHTML();

  document.querySelectorAll('[data-action="logout"]').forEach((el) => {
    el.addEventListener("click", async (ev) => {
      ev.preventDefault();
      await logout();
      window.location.href = url("home.html");
    });
  });

  if (CONFIG_IS_PLACEHOLDER) showConfigWarning();

  return { user, profile };
}

function showRulesWarning() {
  if (document.getElementById("fb-rules-warning")) return;
  const bar = document.createElement("div");
  bar.id = "fb-rules-warning";
  bar.className = "alert alert-danger m-0 rounded-0 text-center";
  bar.innerHTML =
    "<strong>Firestore is refusing reads and writes.</strong> " +
    "The security rules have not been published yet. In the Firebase console open " +
    "<em>Databases &amp; Storage &rarr; Firestore &rarr; Rules</em>, paste the contents of " +
    "<code>firestore.rules</code> from this repo, and click <strong>Publish</strong>.";
  document.body.prepend(bar);
}

function showConfigWarning() {
  if (document.getElementById("fb-config-warning")) return;
  const bar = document.createElement("div");
  bar.id = "fb-config-warning";
  bar.className = "alert alert-warning m-0 rounded-0 text-center";
  bar.innerHTML =
    "<strong>Firebase is not configured yet.</strong> " +
    "Open <code>assets/js/firebase-config.js</code> and paste your project's config. " +
    "Item browsing works without it; accounts, characters and inventories will not.";
  document.body.prepend(bar);
}

/** Turns a Firebase error into something a person can read. */
export function friendlyError(err) {
  const code = err?.code || "";
  const map = {
    "auth/invalid-email": "That email address is not valid.",
    "auth/user-not-found": "Email not found!",
    "auth/wrong-password": "Incorrect password!",
    "auth/invalid-credential": "Incorrect email or password.",
    "auth/email-already-in-use": "An account already uses that email address.",
    "auth/weak-password": "Password must be at least 6 characters.",
    "auth/too-many-requests": "Too many attempts. Try again in a few minutes.",
    "auth/requires-recent-login": "Please enter your current password to confirm this change.",
    "auth/operation-not-allowed":
      "Email/password sign-in is not enabled in the Firebase console yet.",
    "auth/missing-email": "Enter your email address first.",
    "auth/invalid-new-email": "That new email address is not valid.",
    "auth/email-change-needs-verification":
      "Check the new address for a confirmation link to finish the change.",
    "permission-denied":
      "Firestore rejected that request. The security rules have not been published yet \u2014 " +
      "in the Firebase console, open Databases & Storage \u2192 Firestore \u2192 Rules, paste the " +
      "contents of firestore.rules from this repo, and click Publish.",
    "unavailable":
      "Could not reach Firestore. Check your connection, and that a Firestore database " +
      "has been created for this project."
  };
  return map[code] || err?.message || "Something went wrong.";
}

/**
 * Transient confirmation for an action that succeeded.
 *
 * Writes used to complete silently, which left people re-clicking Save to check
 * whether it had worked. Announced politely so screen readers hear it too.
 */
export function toast(message, kind = "success") {
  let host = document.getElementById("toast-host");
  if (!host) {
    host = document.createElement("div");
    host.id = "toast-host";
    host.className = "toast-host";
    host.setAttribute("role", "status");
    host.setAttribute("aria-live", "polite");
    document.body.appendChild(host);
  }

  const el = document.createElement("div");
  el.className = "skyrim-toast skyrim-toast-" + kind;
  el.textContent = message;
  host.appendChild(el);

  setTimeout(() => {
    el.classList.add("is-leaving");
    setTimeout(() => el.remove(), 400);
  }, 3200);
}

/** Small helper for the alert boxes the PHP pages used. */
export function setAlert(el, message, kind = "danger") {
  if (!el) return;
  if (!message) {
    el.innerHTML = "";
    return;
  }
  el.innerHTML = `<div class="alert alert-${kind} text-lg">${esc(message)}</div>`;
}

/* =========================================================
   CHARACTER BUILD  (skills, perks, attributes, carry weight)

   The numbers below are Skyrim's own. Every formula is sourced in
   assets/data/skyrim.json under "sources" — none of it is invented.
   ========================================================= */

let _build = null;

/** Loads assets/data/skyrim.json once and caches it. */
export async function buildData() {
  if (_build) return _build;
  const res = await fetch(url("assets/data/skyrim.json"));
  if (!res.ok) throw new Error("Could not load skyrim.json (" + res.status + ")");
  _build = await res.json();
  return _build;
}

let _spells = null;

/** Loads assets/data/spells.json once and caches it. */
export async function spellData() {
  if (_spells) return _spells;
  const res = await fetch(url("assets/data/spells.json"));
  if (!res.ok) throw new Error("Could not load spells.json (" + res.status + ")");
  _spells = await res.json();
  return _spells;
}

/** The skill spread a freshly created character of this race starts with. */
export function startingSkills(raceId, bd) {
  const race = bd.races[String(raceId)];
  return race ? { ...race.startingSkills } : {};
}

/** Starting attributes. Skyrim gives every race 100/100/100. */
export function startingAttributes(bd) {
  const c = bd.constants;
  return { health: c.startingHealth, magicka: c.startingMagicka, stamina: c.startingStamina };
}

/**
 * Character level, derived from skill training exactly as the game does it.
 *
 *   a skill reaching level S grants S character XP
 *   level N -> N+1 costs (N + 3) * 25
 *
 * Returns the level plus the progress into the next one, so the UI can show
 * a bar rather than just a number.
 */
export function derivedLevel(skills, raceId, bd) {
  const c = bd.constants;
  const start = startingSkills(raceId, bd);

  let xp = 0;
  for (const [sid, level] of Object.entries(skills)) {
    const from = start[sid] ?? c.baseSkill;
    const to = Math.max(from, Number(level) || from);
    // Sum of every rank gained: (to*(to+1) - from*(from+1)) / 2
    xp += (to * (to + 1) - from * (from + 1)) / 2 * c.xpPerSkillRank;
  }

  let level = 1;
  let needed = c.xpLevelUpBase + c.xpLevelUpMult * level;
  while (xp >= needed) {
    xp -= needed;
    level += 1;
    needed = c.xpLevelUpBase + c.xpLevelUpMult * level;
  }

  return { level, xpIntoLevel: Math.round(xp), xpForNextLevel: needed };
}

/** One perk point and one attribute pick per level gained after the first. */
export function pointsAvailable(level, perks, attributePicks) {
  const earned = Math.max(0, level - 1);
  const perksSpent = Object.values(perks || {}).reduce((s, r) => s + (Number(r) || 0), 0);
  const picksSpent = (attributePicks?.health || 0) + (attributePicks?.magicka || 0) +
                     (attributePicks?.stamina || 0);
  return {
    earned,
    perkPointsSpent: perksSpent,
    perkPointsLeft: earned - perksSpent,
    attributePicksSpent: picksSpent,
    attributePicksLeft: earned - picksSpent
  };
}

/** Current Health / Magicka / Stamina after level-up allocation. */
export function attributes(attributePicks, bd) {
  const c = bd.constants;
  const p = attributePicks || {};
  return {
    health:  c.startingHealth  + c.attributePerLevel * (p.health  || 0),
    magicka: c.startingMagicka + c.attributePerLevel * (p.magicka || 0),
    stamina: c.startingStamina + c.attributePerLevel * (p.stamina || 0)
  };
}

/** Carry weight: 300 base, plus 5 for every level-up point put into Stamina. */
export function carryCapacity(attributePicks, bd) {
  const c = bd.constants;
  return c.carryWeightBase + c.carryWeightPerStaminaPick * (attributePicks?.stamina || 0);
}

/** Total ranks taken in one perk, 0 if untaken. */
export function perkRank(perks, perkId) {
  return Number(perks?.[perkId] || 0);
}

/** Is this rank reachable — skill high enough, and prerequisite taken? */
export function perkAvailable(perk, nextRank, skillLevel, perks, tree) {
  if (nextRank > perk.ranks) return false;
  if (skillLevel < perk.req[nextRank - 1]) return false;
  if (perk.prereq) {
    const parent = tree.find((p) => p.id === perk.prereq);
    if (parent && perkRank(perks, perk.prereq) < 1) return false;
  }
  return true;
}

/** Sums a perk effect of one type across a tree, in percent. */
function effectPct(tree, perks, type) {
  let total = 0;
  for (const perk of tree || []) {
    if (perk.effect?.type !== type) continue;
    total += (perk.effect.perRank || 0) * perkRank(perks, perk.id);
  }
  return total;
}

function hasEffect(tree, perks, type) {
  return (tree || []).some((p) => p.effect?.type === type && perkRank(perks, p.id) > 0);
}

/**
 * What one weapon actually hits for, given this character.
 *   damage = base * (1 + 0.005 * skill) * (1 + perk%)
 */
export function weaponDamage(item, skills, perks, bd) {
  const base = Number(item.damage) || 0;
  if (!base) return null;

  const skillId = bd.classificationSkill[String(item.classification_id)];
  if (!skillId) return { base, total: base, skillId: null, skillPct: 0, perkPct: 0 };

  const skill = Number(skills?.[skillId] ?? bd.constants.baseSkill);
  const skillMult = 1 + bd.constants.weaponDamagePerSkillPoint * skill;
  const perkPct = effectPct(bd.perks[String(skillId)], perks, "weaponDamagePct");
  const total = base * skillMult * (1 + perkPct / 100);

  return {
    base,
    total: Math.round(total * 10) / 10,
    skillId,
    skillLevel: skill,
    skillPct: Math.round((skillMult - 1) * 1000) / 10,
    perkPct
  };
}

/**
 * What one armour piece is actually worth.
 *   rating = base * (1 + 0.004 * skill) * (1 + perk%) * (1 + setBonus%)
 * The set bonus only applies when all four armour slots are the same type.
 */
export function armorPieceRating(item, skills, perks, bd, fullSet = false) {
  const base = Number(item.defence) || 0;
  if (!base) return null;

  const skillId = bd.classificationSkill[String(item.classification_id)];
  if (!skillId) return { base, total: base, skillId: null, skillPct: 0, perkPct: 0, setPct: 0 };

  const skill = Number(skills?.[skillId] ?? bd.constants.baseSkill);
  const skillMult = 1 + bd.constants.armorRatingPerSkillPoint * skill;
  const tree = bd.perks[String(skillId)];
  const perkPct = effectPct(tree, perks, "armorRatingPct");
  const setPct = fullSet ? effectPct(tree, perks, "setBonusPct") : 0;
  const total = base * skillMult * (1 + perkPct / 100) * (1 + setPct / 100);

  return {
    base,
    total: Math.round(total * 10) / 10,
    skillId,
    skillLevel: skill,
    skillPct: Math.round((skillMult - 1) * 1000) / 10,
    perkPct,
    setPct
  };
}

/**
 * Damage reduction from a set of worn armour.
 *   (displayed rating + 25 per worn piece) * 0.12%, capped at 80%.
 */
export function damageReduction(displayedRating, piecesWorn, bd) {
  const c = bd.constants;
  const hidden = c.hiddenArmorPerPiece * Math.min(piecesWorn, 4);
  const pct = (displayedRating + hidden) * c.damageReductionPerArmorPoint;
  return {
    percent: Math.min(pct, c.maxDamageReduction),
    capped: pct >= c.maxDamageReduction,
    ratingForCap: c.armorCapRating
  };
}

/* ---------------------------------------------------------
   SPELLS

   Two things are true in Skyrim and both matter here:

   1. Raising a magic skill does NOT make its spells hit harder. It makes
      them cheaper. The skill multiplier below is the vanilla one,
      1 - (skill/400)^0.65 — about -12% at skill 15 and -41% at skill 100.
   2. Damage comes from perks instead: Augmented Flames / Frost / Shock,
      +25% per rank, to that element only.

   The half-cost perks (Novice / Apprentice / ... Destruction) halve the
   cost of spells of that tier in that school, on top of the skill scaling.
   --------------------------------------------------------- */

/** The vanilla skill multiplier on spell cost: 1 at skill 0, 0.594 at 100. */
export function spellCostSkillMultiplier(skillLevel, bd) {
  const c = bd.constants;
  const s = Math.max(0, Number(skillLevel) || 0);
  return 1 - Math.pow(s / c.spellCostSkillDivisor, c.spellCostSkillExponent);
}

/** Is the half-cost perk for this spell's tier and school taken? */
export function spellHalfCostTaken(spell, perks, bd) {
  const tree = bd.perks[String(spell.skillId)] || [];
  return tree.some(
    (p) => p.effect?.type === "spellCostHalf" &&
           p.effect.tier === spell.tier &&
           perkRank(perks, p.id) > 0
  );
}

/**
 * What one spell actually costs this character to cast.
 *   cost = base * (1 - (skill/400)^0.65) * (half-cost perk ? 0.5 : 1)
 * Returns null for the DLC spells whose base cost no source published.
 */
export function spellCost(spell, skills, perks, bd) {
  // null, not zero: the DLC spells whose base cost no source published.
  if (spell.cost === null || spell.cost === undefined || spell.cost === "") return null;
  const base = Number(spell.cost);
  if (!Number.isFinite(base)) return null;

  const skill = Number(skills?.[spell.skillId] ?? bd.constants.baseSkill);
  const skillMult = spellCostSkillMultiplier(skill, bd);
  const halved = spellHalfCostTaken(spell, perks, bd);
  const perkMult = halved ? bd.constants.spellCostHalfPerkMult : 1;

  return {
    base,
    skillLevel: skill,
    skillPct: -Math.round((1 - skillMult) * 1000) / 10,
    halved,
    total: Math.round(base * skillMult * perkMult),
    per: spell.costPer || "cast"
  };
}

/**
 * What one spell actually hits for. Skill does nothing here — only the
 * Augmented perk for that element does.
 */
export function spellDamage(spell, perks, bd) {
  const base = Number(spell.damage);
  if (!Number.isFinite(base) || !base) return null;

  const tree = bd.perks[String(spell.skillId)] || [];
  let perkPct = 0;
  for (const perk of tree) {
    if (perk.effect?.type !== "spellDamagePct") continue;
    if (perk.effect.element !== spell.element) continue;
    perkPct += (perk.effect.perRank || 0) * perkRank(perks, perk.id);
  }

  return {
    base,
    perkPct,
    total: Math.round(base * (1 + perkPct / 100) * 10) / 10,
    per: spell.damagePer || "hit"
  };
}

/**
 * Everything the character sheet and the inventory page need, in one call.
 * `inventory` is the rows from listInventory(); `items` the static item list.
 */
export function buildSummary(
  { raceId, skills, perks, attributePicks }, inventory, itemsById, bd, knownSpells
) {
  const lvl = derivedLevel(skills, raceId, bd);
  const attrs = attributes(attributePicks, bd);
  const points = pointsAvailable(lvl.level, perks, attributePicks);
  const capacity = carryCapacity(attributePicks, bd);

  // Which armour slots are filled, and by which type.
  const slotType = {};
  let carried = 0;
  let bestWeapon = null;
  const armourPieces = [];

  for (const row of inventory || []) {
    const item = itemsById.get(row.itemId);
    if (!item) continue;
    const qty = Number(row.quantity) || 0;

    const skillId = bd.classificationSkill[String(item.classification_id)];
    const tree = bd.perks[String(skillId)];
    const weightless = tree && hasEffect(tree, perks, "weightless");
    if (!weightless) carried += (Number(item.weight) || 0) * qty;

    if (item.defence) {
      const slot = bd.armorSlots[String(item.category_id)];
      if (slot && !slotType[slot]) slotType[slot] = skillId;
      armourPieces.push(item);
    }
    if (item.damage) {
      const d = weaponDamage(item, skills, perks, bd);
      if (d && (!bestWeapon || d.total > bestWeapon.damage.total)) {
        bestWeapon = { item, damage: d };
      }
    }
  }

  // A full set means all four slots filled by the same armour skill.
  const filled = Object.values(slotType);
  const fullSet = filled.length === 4 && filled.every((s) => s === filled[0]);

  // Best single piece per slot, which is what the character would wear.
  const worn = {};
  for (const item of armourPieces) {
    const slot = bd.armorSlots[String(item.category_id)];
    if (!slot) continue;
    const r = armorPieceRating(item, skills, perks, bd, fullSet);
    if (!r) continue;
    if (!worn[slot] || r.total > worn[slot].rating.total) worn[slot] = { item, rating: r };
  }

  const displayed = Object.values(worn).reduce((s, w) => s + w.rating.total, 0);
  const dr = damageReduction(displayed, Object.keys(worn).length, bd);

  return {
    level: lvl,
    attributes: attrs,
    points,
    carry: {
      capacity,
      carried: Math.round(carried * 100) / 100,
      remaining: Math.round((capacity - carried) * 100) / 100,
      overEncumbered: carried > capacity,
      usedPercent: Math.min(100, Math.round((carried / capacity) * 1000) / 10)
    },
    armour: {
      worn,
      fullSet,
      displayedRating: Math.round(displayed * 10) / 10,
      damageReduction: Math.round(dr.percent * 10) / 10,
      capped: dr.capped
    },
    bestWeapon,
    spells: spellSummary(knownSpells, skills, perks, bd)
  };
}

/**
 * The known-spell side of the summary: how many per school, the cheapest
 * thing this character can still cast, and the hardest-hitting one.
 */
export function spellSummary(knownSpells, skills, perks, bd) {
  const known = knownSpells || [];
  const bySchool = {};
  let bestSpell = null;
  let totalCost = 0;
  let priced = 0;

  for (const spell of known) {
    const sid = String(spell.skillId);
    const cost = spellCost(spell, skills, perks, bd);
    const damage = spellDamage(spell, perks, bd);

    bySchool[sid] = (bySchool[sid] || 0) + 1;
    if (cost) { totalCost += cost.total; priced += 1; }

    if (damage && (!bestSpell || damage.total > bestSpell.damage.total)) {
      bestSpell = { spell, damage, cost };
    }
  }

  return {
    count: known.length,
    bySchool,
    bestSpell,
    averageCost: priced ? Math.round(totalCost / priced) : null
  };
}
