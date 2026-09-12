# Backup of the original PHP project

Everything in this folder is the project exactly as it was before the conversion to
static HTML / CSS / JavaScript. Nothing here has been edited.

- `*.php`, `general_information/`, `login/`, `my_account/`, `my_character/`,
  `page_formatting/` — the original PHP pages, including `database.php` (the MySQL
  PDO connection) and `config.php` (the `BASE_URL` constant).
- `assets/css/` — the two stylesheets as they were. The live copies at
  `../assets/css/` differ only in two image paths that were absolute to the old
  server layout.
- `extra_content/` — the MySQL dump and the ERD.

**Not duplicated here:** `assets/images/`. Those files were not touched by the
conversion, so the originals are still the only copies, in place at `../assets/images/`.

To run this version you would need a PHP server with MySQL, the database imported
from `extra_content/skyrim-combat-optimization.sql`, and credentials filled into
`database.php`.
