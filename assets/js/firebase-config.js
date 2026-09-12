/**
 * =========================================================
 * FILE: firebase-config.js
 * PROJECT: Skyrim Character Combat Optimization System
 * AUTHOR: C.J. Wiebe
 * =========================================================
 * DESCRIPTION:
 * Firebase project credentials. This replaces database.php.
 *
 * >>> PASTE YOUR OWN VALUES BELOW. <<<
 * Get them from the Firebase console:
 *   Project settings -> General -> Your apps -> Web app -> SDK setup and configuration -> Config
 *
 * These keys are NOT secrets. A Firebase web API key only identifies your
 * project; it grants no access on its own. Your data is protected by the
 * Firestore security rules in firestore.rules, not by hiding this file.
 * =========================================================
 */

export const firebaseConfig = {
  apiKey: "PASTE_YOUR_API_KEY",
  authDomain: "PASTE_YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "PASTE_YOUR_PROJECT_ID",
  storageBucket: "PASTE_YOUR_PROJECT_ID.firebasestorage.app",
  messagingSenderId: "PASTE_YOUR_SENDER_ID",
  appId: "PASTE_YOUR_APP_ID"
};
