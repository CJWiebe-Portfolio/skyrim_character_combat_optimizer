/**
 * =========================================================
 * FILE: firebase-config.js
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: C.J. Wiebe
 * =========================================================
 * DESCRIPTION:
 * Firebase project credentials. This replaces database.php.
 *
 * IMPORTANT: the `export` keyword below is required. app.js loads this file as
 * an ES module with `import { firebaseConfig } from "./firebase-config.js"`.
 * The snippet the Firebase console gives you is written for a plain <script>
 * tag and says just `const firebaseConfig = {...}` — without `export` the
 * import fails, app.js never runs, and every page loses its navbar, footer
 * and behaviour. If you ever re-copy the config from the console, add the
 * `export` back.
 *
 * These keys are NOT secrets. A Firebase web API key only identifies your
 * project; it grants no access on its own. Your data is protected by the
 * Firestore security rules in firestore.rules, not by hiding this file.
 * =========================================================
 */

export const firebaseConfig = {
  apiKey: "AIzaSyAajCw5LC9-LLxstWqZfhBEkSvGHALKlSQ",
  authDomain: "skyrim-optimizater.firebaseapp.com",
  projectId: "skyrim-optimizater",
  storageBucket: "skyrim-optimizater.firebasestorage.app",
  messagingSenderId: "125414880139",
  appId: "1:125414880139:web:6a69e0a27db28cbe91758e",
  measurementId: "G-DTVKNXYRET"
};
