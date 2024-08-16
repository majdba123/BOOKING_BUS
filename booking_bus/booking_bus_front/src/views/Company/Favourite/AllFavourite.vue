<template>
    <body>
        <div class="container">
            <!-- Aside section start -->
            <aside ref="sideMenu">
                <!-- Start top -->
                <div class="top">
                    <div class="logo">
                        <h2>T<span class="danger">RAVEL</span></h2>
                    </div>
                    <div class="close" @click="closeMenu">
                        <span class="material-icons" aria-label="Close"
                            >close</span
                        >
                    </div>
                </div>
                <!-- End top -->

                <!-- Start sidebar -->
                <SidebarCompany />
                <!-- End sidebar -->
            </aside>

            <!-- Main section start -->
            <AllFavourite1 />
            <!-- Main section end -->

            <!-- Right section start -->
            <div class="right">
                <!--start top-->
                <div class="top">
                    <button id="menu_bar" @click="openMenu">
                        <span class="material-icons">menu</span>
                    </button>
                    <div
                        class="theme-toggler"
                        ref="themeToggler"
                        @click="toggleTheme"
                    >
                        <span class="material-icons active">light_mode</span>
                        <span class="material-icons">dark_mode</span>
                    </div>
                    <div class="profile">
                        <div class="info">
                            <p><b>Babar</b></p>
                            <p>Admin</p>
                        </div>
                        <div class="profile-photo">
                            <img src="@/assets/busss.png" alt="Profile" />
                        </div>
                    </div>
                </div>
                <!--end top-->

                <!--start recent_updates-->

                <div class="recent_updates">
                    <h2>Name Companys</h2>
                    <div class="updates">
                        <div class="update">
                            <div class="profile-photo">
                                <img src="@/assets/busss.png" alt="Profile" />
                            </div>
                            <div class="message">
                                <p><b>Babar</b> Received his order</p>
                            </div>
                        </div>
                        <div class="update">
                            <div class="profile-photo">
                                <img src="@/assets/busss.png" alt="Profile" />
                            </div>
                            <div class="message">
                                <p><b>Babar</b> Received his order</p>
                            </div>
                        </div>
                        <div class="update">
                            <div class="profile-photo">
                                <img src="@/assets/busss.png" alt="Profile" />
                            </div>
                            <div class="message">
                                <p><b>Babar</b> Received his order</p>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end recent_updates-->
            </div>
            <!-- Right section end -->
        </div>
    </body>
</template>

<script>
import SidebarCompany from "@/components/SidebarCompany.vue";
import AllFavourite1 from "@/components/AllFavourite.vue";

export default {
    name: "AllFavourite",
    methods: {
        openMenu() {
            const sideMenu = this.$refs.sideMenu;
            if (sideMenu) {
                sideMenu.style.display = "block";
            }
        },
        closeMenu() {
            const sideMenu = this.$refs.sideMenu;
            if (sideMenu) {
                sideMenu.style.display = "none";
            }
        },
        toggleTheme() {
            const themeToggler = this.$refs.themeToggler;
            if (themeToggler) {
                themeToggler
                    .querySelector("span:nth-child(1)")
                    .classList.toggle("active");
                themeToggler
                    .querySelector("span:nth-child(2)")
                    .classList.toggle("active");
            }
        },
    },
    components: { SidebarCompany, AllFavourite1 },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap");

:root {
    --clr-primary: #7380ec;
    --clr-danger: #ff7782;
    --clr-success: #41f1b6;
    --clr-white: #fff;
    --clr-info-dark: #7d8da1;
    --clr-info-light: #e4e9f7;
    --clr-dark: #363949;
    --clr-warning: #ffbb55;
    --clr-light: rgba(132, 139, 200, 0.18);
    --clr-primary-variant: #111e88;
    --clr-dark-variant: #677483;
    --clr-color-background: #f6f6f9;

    --card-border-radius: 2rem;
    --border-radius-1: 0.4rem;
    --border-radius-2: 0.8rem;
    --border-radius-3: 1.2rem;

    --card-padding: 1.8rem;
    --padding-1: 1.2rem;

    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}
.dark-theme-variables {
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --box-shadow: 0 2rem 3rem var(--clr-light);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
    border: 0;
    list-style: none;
    appearance: none;
}

body {
    font-family: "Poppins", sans-serif;
    width: 100%;
    height: 100%;
    font-size: 0.88rem;
    user-select: none;
    background: #f6f6f9;
    overflow-y: auto;
}

.container {
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
    height: 100vh;
    overflow-y: auto;
}

a {
    color: #363949;
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
}

h2 {
    font-size: 1.4rem;
}

h3 {
    font-size: 0.87rem;
}

h4 {
    font-size: 0.8rem;
}

h5 {
    font-size: 0.77rem;
}

small {
    font-size: 0.75rem;
}

.profile-photo img {
    width: 2.8rem;
    height: 2.8rem;
    border-radius: 50%;
    overflow: hidden;
}

.text-muted {
    color: #7d8da1;
}

.primary {
    color: #7380ec;
}

.success {
    color: var(--clr-success);
}

.danger {
    color: #ff7782;
}

.warning {
    color: #ffbb55;
}

/* aside */
aside {
    height: 100vh;
    background-color: #fff;
    display: flex;
    flex-direction: column;
    padding: 1rem;
}

aside .top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

aside .logo {
    display: flex;
    gap: 1rem;
}

/* Main section styles */
/*
        start right side
***************************** */
.right {
    margin-top: 1.4rem;
    padding: 1rem;
    background-color: #f6f6f9;
    grid-column: span 1;
    overflow-y: auto; /* تأكد من أن التمرير الرأسي مسموح */
}

.right .top {
    display: flex;
    justify-content: space-between;
    gap: 2rem;
}

.right .top button {
    display: none;
}

.right .theme-toggler {
    background-color: #fff;
    display: flex;
    justify-content: space-between;
    height: 1.6rem;
    width: 4.2rem;
    cursor: pointer;
    border-radius: 10px;
}

.right .theme-toggler span {
    font-size: 1.2rem;
    width: 50%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.right .theme-toggler span.active {
    background-color: #7380ec;
    color: #fff;
    border-radius: 10px;
}

.right .profile {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.right .profile .info p {
    margin: 0;
}

.right .profile .profile-photo img {
    width: 2.8rem;
    height: 2.8rem;
    border-radius: 50%;
    overflow: hidden;
}

/***recent update */
.right .recent_updates {
    margin-top: 1rem;
    margin-left: -20px;
}
.right .recent_updates h2 {
    color: #363949;
    margin-bottom: 14px;
}

.right .recent_updates .updates {
    background-color: #fff;
    padding: 1.8rem;
    border-radius: 2rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
}

.right .recent_updates .updates:hover {
    box-shadow: none;
}

.right .recent_updates .update {
    display: grid;
    grid-template-columns: 2.6rem auto;
    gap: 1rem;
    margin-bottom: 1rem;
}

/**********
media query
********** */
@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 14rem;
    }
    aside .sidebar h3 {
        display: none;
    }
    aside .sidebar a span.msg_count {
        padding: 1px 4px;
        font-size: 10px;
        border-radius: 0.2rem;
    }
    aside .sidebar a:hover span {
        margin: 0;
    }
    aside .top .close span {
        display: none;
    }
    aside .sidebar a:last-child {
        position: relative;
        margin-top: 1.8rem;
    }

    main .insights {
        display: grid;
        grid-template-columns: repeat(1, 1fr);
        gap: 1.6rem;
        padding: 40px;
    }
}

/* Mobile Responsive */
@media screen and (max-width: 768px) {
    .container {
        width: 100%;
        grid-template-columns: repeat(1, 1fr);
    }

    aside {
        position: fixed;
        width: 18rem;
        z-index: 3;
        background-color: #fff;
        display: none;
        left: -100px;
        animation: menuAni 1s forwards;
    }
    @keyframes menuAni {
        to {
            left: 0;
        }
    }

    aside .logo {
        display: inline;
    }

    aside .sidebar h3 {
        display: inline;
    }

    aside .sidebar a {
        width: 100%;
        height: 3.4rem;
    }

    aside .top .close span {
        display: inline;
        position: absolute;
        right: 0;
        font-size: 35px;
        margin-right: 30px;
    }

    .right .top {
        position: fixed;
        top: 0;
        left: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 0.8rem;
        background-color: #fff;
        width: 100%;
        height: 4.6rem;
        z-index: 2;
        box-shadow: 0 1rem 1rem 0 2rem 3rem rgba(132, 139, 200, 0.18);
        margin: 0;
    }

    main .insights {
        display: grid;
        grid-template-columns: repeat(1, 1fr);
        gap: 1.6rem;
        padding: 40px;
    }

    main .recent_orders {
        padding: 30px;
        margin: 0 auto;
    }
    main .date {
        margin-top: 40px;
        margin-left: 44px;
    }

    .right .profile {
        position: absolute;
        left: 70%;
    }

    .right .recent_updates {
        padding: 30px;
    }

    .right .top button {
        display: inline-block;
        background: transparent;
        cursor: pointer;
        color: #363949;
        position: absolute;
        left: 1rem;
    }

    .theme-toggler {
        display: flex;
        justify-content: space-between;
        height: 1.6rem;
        width: 4.2rem;
        cursor: pointer;
        border-radius: 10px;
    }

    .theme-toggler span {
        font-size: 1.2rem;
        width: 50%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .theme-toggler span.active {
        background-color: #7380ec;
        color: #fff;
        border-radius: 10px;
    }
}
</style>
