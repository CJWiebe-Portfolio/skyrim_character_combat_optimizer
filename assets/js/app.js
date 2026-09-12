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
  updateEmail,
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

/** Creates the Auth user and their profile document in one step. */
export async function signup({ firstName, lastName, email, password, dob }) {
  const cred = await createUserWithEmailAndPassword(auth, email, password);
  await setDoc(doc(db, "users", cred.user.uid), {
    firstName,
    lastName,
    email,
    dob: dob || "",
    role: "user",
    createdAt: serverTimestamp()
  });
  return cred.user;
}

/** Firebase requires a recent login before email/password/account changes. */
export function reauth(user, password) {
  const cred = EmailAuthProvider.credential(user.email, password);
  return reauthenticateWithCredential(user, cred);
}

export { updatePassword, updateEmail, deleteUser };

/* =========================================================
   PROFILE  (was the `accounts` table)
   users/{uid}
   ========================================================= */

export async function getProfile(uid) {
  const snap = await getDoc(doc(db, "users", uid));
  return snap.exists() ? snap.data() : null;
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
  const ref = await addDoc(charsCol(uid), {
    name,
    raceId: Number(raceId),
    characterNumber: next,
    createdAt: serverTimestamp()
  });
  return ref.id;
}

export function updateCharacter(uid, cid, { name, raceId }) {
  return updateDoc(charDoc(uid, cid), { name, raceId: Number(raceId) });
}

/** Deletes the character and every inventory row underneath it. */
export async function deleteCharacter(uid, cid) {
  const inv = await getDocs(collection(db, "users", uid, "characters", cid, "inventory"));
  const batch = writeBatch(db);
  inv.docs.forEach((d) => batch.delete(d.ref));
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
             class="d-inline-block align-text-middle">Skyrim Optimizer</a>

      <button class="navbar-toggler skyrim-toggler" type="button"
              data-bs-toggle="collapse" data-bs-target="#navbarNav">
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
          <h5 class="fw-bold text-lg">&#9876;&#65039; Skyrim Optimizer</h5>
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
          <p class="small mb-0 text-m">C.J. Wiebe</p>
        </div>

      </div>

      <hr class="border-light">

      <div class="text-center text-lg">
        ${now.getFullYear()} - Skyrim Combat Optimization System
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
      profile = await getProfile(user.uid);
    } catch (e) {
      console.warn("Could not load profile:", e);
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
    "permission-denied": "You do not have permission to do that."
  };
  return map[code] || err?.message || "Something went wrong.";
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
