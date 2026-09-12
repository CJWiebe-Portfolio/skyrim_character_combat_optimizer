    <?php
    /**
     * =========================================================
     * FILE: navbar.php
     * PROJECT: Skyrim Character Combat Optimization System
     * AUTHOR: Cygnus J. Wiebe
     * DATE: April 2026
     * COURSE: INFS 657 - McGill University
     * =========================================================
     * DESCRIPTION:
     * The general navbar for all pages.
     * =========================================================
     */

    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    $current_page = basename($_SERVER['PHP_SELF']);
    ?>


    <nav class="navbar navbar-expand-lg skyrim-navbar shadow-soft sticky-top">
        <div class="container">

            <!-- Brand -->
            <a class="navbar-brand d-flex align-items-center gap-2 font-title"
                href="../main/home.php">
                <img src="../assets/images/skyrim_icon.png" alt="Skyrim Logo" width="40" height="40" class="d-inline-block align-text-middle">Skyrim Optimizer</a>

            <!-- Mobile toggle -->
            <button class="navbar-toggler skyrim-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Links -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto gap-lg-2">

                    <li class="nav-item">
                        <a class="nav-link nav-btn<?= $current_page == 'home.php' ? 'active' : '' ?>"
                            href="<?= BASE_URL ?>../main/home.php">Home</a>
                    </li>
                    <!-- The navbar includes links to the Home page, References page, and conditionally shows links for My Characters, My Account, Logout, Create Account, and Login based on whether the user is logged in or not. -->
                    <li class="nav-item">
                        <a class="nav-link nav-btn <?= $current_page == 'references.php' ? 'active' : '' ?>"
                            href="<?= BASE_URL ?>/main/references.php">References</a>
                    </li>

                    <?php if (isset($_SESSION['email'])): ?>

                        <li class="nav-item">
                            <a class="nav-link nav-btn <?= $current_page == 'characters.php' ? 'active' : '' ?>"
                                href="<?= BASE_URL ?>/my_character/characters.php">My Characters</a>
                        </li>

                    <!-- Dropdown (cleaner UI) -->
                    <li class="nav-item dropdown">
                        <a class="nav-link nav-btn dropdown-toggle"
                           href="#"
                           data-bs-toggle="dropdown">
                            <?= htmlspecialchars($_SESSION['first_name']) ?>
                        </a>

                        <ul class="dropdown-menu dropdown-menu-end skyrim-dropdown">
                            <li>
                                <a class="dropdown-item"
                                   href="../my_account/read_account.php">
                                   My Account
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item"
                                   href="<?= BASE_URL ?>/login/logout.php">
                                   Logout
                                </a>
                            </li>
                        </ul>
                    </li>

                <?php else: ?>
                    <!-- If the user is not logged in, show Create Account and Login links -->
                    <li class="nav-item">
                        <a class="nav-link nav-btn"
                           href="<?= BASE_URL ?>/account/create_user.php">
                           Create Account
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-btn nav-btn-primary"
                           href="<?= BASE_URL ?>/login/login.php">
                           Login
                        </a>
                    </li>
                    <?php endif; ?>

            </div>
        </div>
    </nav>