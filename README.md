# Skyrim Character Combat Optimization System

A static (HTML / CSS / JavaScript) build of the Skyrim character combat optimizer,
hostable on GitHub Pages, with Firebase standing in for the self-hosted MySQL database.

**Author:** C.J. Wiebe

---

## What changed from the PHP version

| Old (PHP + MySQL) | New (static + Firebase) |
| --- | --- |
| `database.php` (PDO to MySQL) | `assets/js/firebase-config.js` + `assets/js/app.js` |
| `$_SESSION` / `session_start.php` | Firebase Auth session (`onAuthStateChanged`) |
| `accounts` table | Firebase Auth users + `users/{uid}` in Firestore |
| `character` table | `users/{uid}/characters/{characterId}` |
| `inventory_item` table | `users/{uid}/characters/{characterId}/inventory/{itemId}` |
| (new) spellbook | `users/{uid}/characters/{characterId}/spellbook/{spellId}` |
| `item`, `category`, `perk`, `race`, … tables | `assets/data/items.json` (static, read-only) |
| `header.php` / `navbar.php` / `footer.php` | `renderChrome()` in `assets/js/app.js` |
| `BASE_URL` in `config.php` | `window.SITE_ROOT`, set by each page |
| Server-side `WHERE account_id = …` checks | `firestore.rules` |

The original PHP project is preserved untouched in [`backup/`](backup/).

The 570 weapons and armour pieces are reference data that never changes per user,
so they ship as a static JSON file. That page loads instantly, costs nothing in
Firebase quota, and works even before Firebase is configured.

---

## Setting up Firebase

You only need to do this once. Everything below is on the free Spark plan.

### 1. Create the project

1. Go to <https://console.firebase.google.com> and click **Add project**.
2. Name it (for example `skyrim-optimizer`). Google Analytics is optional — you can turn it off.

### 2. Register a web app

1. In the project, click the **`</>`** (Web) icon on the overview page.
2. Give it a nickname. **Do not** tick "Firebase Hosting" — GitHub Pages is doing the hosting.
3. Firebase shows you a `firebaseConfig` object. Keep that page open.

### 3. Paste the config

Open `assets/js/firebase-config.js` and replace the placeholder values with the ones
Firebase just gave you:

```js
export const firebaseConfig = {
  apiKey: "AIza…",
  authDomain: "skyrim-optimizer.firebaseapp.com",
  projectId: "skyrim-optimizer",
  storageBucket: "skyrim-optimizer.firebasestorage.app",
  messagingSenderId: "1234567890",
  appId: "1:1234567890:web:abc123"
};
```

These values are **not secrets** — they are meant to ship in the browser. A Firebase
web API key only identifies your project. Your data is protected by the security
rules in step 5, not by hiding this file.

### 4. Turn on Email/Password sign-in

1. In the console: **Build → Authentication → Get started**.
2. Under **Sign-in method**, enable **Email/Password** and save.
3. Under **Settings → Authorized domains**, add your GitHub Pages domain
   (`your-username.github.io`). `localhost` is already there for local testing.

If you skip this step, signing up fails with "Email/password sign-in is not enabled".

### 5. Create the database and publish the rules

1. **Build → Firestore Database → Create database**.
2. Pick a location near you, and start in **production mode** (the rules below replace
   whatever it starts with).
3. Open the **Rules** tab, delete what is there, paste the contents of
   [`firestore.rules`](firestore.rules), and click **Publish**.

Those rules say: a signed-in user may read and write everything under their own
`users/{uid}` document and nothing else. That is the server-enforced version of the
`WHERE account_id = $_SESSION['account_id']` checks the PHP pages used to do.

### 6. Create your first account

Open the site, click **Create Account**, and register. Collections appear in Firestore
automatically the first time something is written — there is nothing to create by hand.

---

## Publishing on GitHub Pages

1. Commit and push this folder to your repository's default branch.
2. On GitHub: **Settings → Pages**.
3. Under **Build and deployment**, set **Source** to *Deploy from a branch*, and pick
   your branch with folder **`/ (root)`**.
4. Save. After a minute the site is live at
   `https://<your-username>.github.io/<repo-name>/`.
5. Add that `<your-username>.github.io` domain to Firebase's authorized domains
   (step 4 above) if you have not already.

All links in the site are relative, so it works both at a domain root and under a
`/repo-name/` subpath.

---

## Running it locally

Because the pages use ES modules and `fetch`, opening `index.html` straight from the
filesystem will not work — you need a local server:

```bash
# Python
python3 -m http.server 8000

# or Node
npx serve .
```

Then open <http://localhost:8000>.

---

## Layout

```
index.html                      Splash page, redirects to home
home.html                       Dashboard
references.html                 Sources used by the project
firestore.rules                 Security rules — paste into the Firebase console

general_information/
  all_items.html                All 570 weapons and armour, filter + sort

login/
  login.html                    Sign in
  create_account.html           Register

my_account/
  read_account.html             View profile
  update_account.html           Edit profile, email, password
  delete_account.html           Delete account and all its data

my_character/
  characters.html               List characters
  create_character.html         New character
  read_character.html           Character detail
  update_character.html         Edit character
  inventory.html                Add / remove / adjust inventory items

assets/
  css/                          Original stylesheets, unchanged apart from one image path
  images/                       Original images
  js/app.js                     Firebase init, auth, Firestore access, shared navbar/footer
  js/firebase-config.js         >>> your Firebase credentials go here <<<
  data/items.json               Item, category, perk, race and upgrade reference data
  data/skyrim.json              Races, skills, perk trees and every build formula
  data/spells.json              All 111 spells, by school of magic, with costs and effects

backup/                         The original PHP project, untouched
```

## Notes and known differences

- **Passwords** are handled entirely by Firebase Auth. The old bcrypt hashes in the
  SQL dump do not carry over — existing users need to register again.
- **Password minimum** is 8 characters in the site's own validation (matching the PHP
  rules); Firebase itself enforces 6.
- **Changing your email or password** asks for your current password first. Firebase
  requires a recent sign-in before those operations.
- **Deleting an account** removes its characters and inventories first, then the
  profile document, then the Auth user — in that order, because the security rules
  stop applying once the Auth user is gone.
- **The `character_skill` table** in the original SQL dump was empty and unused by any
  page, so it has no equivalent here.
- **Item data is read-only.** To change an item, edit `assets/data/items.json` and push.
- **Spell data is read-only too**, in `assets/data/spells.json`. The 19 Dawnguard and
  Dragonborn spells are listed with school and tier but no base magicka cost, because no
  source consulted published one; the sheet shows a dash rather than a guessed number.
