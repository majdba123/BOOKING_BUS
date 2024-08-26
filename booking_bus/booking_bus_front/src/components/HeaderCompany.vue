<template>
    <main>
        <h1>{{ x }}</h1>
        <div class="top-bar">
            <div class="profile-menu">
                <div
                    class="theme-toggler"
                    ref="themeToggler"
                    @click="toggleTheme"
                >
                    <span class="material-icons active">light_mode</span>
                    <span class="material-icons">dark_mode</span>
                </div>
                <img
                    :src="profileImage"
                    alt="Profile"
                    class="profile-picture"
                    @click="toggleProfileMenu"
                />
                <ul v-if="showProfileMenu" class="dropdown-menu">
                    <li @click="goToProfile">Go to Profile</li>
                    <li @click="logout">Logout</li>
                </ul>
            </div>
        </div>
    </main>
</template>

<script>
import store from "@/store";

export default {
    name: "HeaderCompany",
    data() {
        return {
            x: store.state.x,
            showProfileMenu: false,
            profileImage: "",
            isDarkMode: false,
        };
    },
    methods: {
        toggleProfileMenu() {
            this.showProfileMenu = !this.showProfileMenu;
            if (this.showProfileMenu) {
                setTimeout(() => {
                    const dropdownMenu =
                        this.$el.querySelector(".dropdown-menu");
                    if (dropdownMenu) {
                        dropdownMenu.classList.add("show");
                    }
                }, 10);
            } else {
                const dropdownMenu = this.$el.querySelector(".dropdown-menu");
                if (dropdownMenu) {
                    dropdownMenu.classList.remove("show");
                }
            }
        },
        goToProfile() {
            this.$router.push("/ProfileCompany");
        },
        logout() {
            store.dispatch("logout");
            this.$router.push("/");
        },
        fetchProfileInfo() {
            const userDataFrame = {
                image: "path/to/profile-image.jpg",
            };
            this.profileImage = userDataFrame.image;
        },
        toggleTheme() {
            this.isDarkMode = !this.isDarkMode;
            document.body.classList.toggle(
                "dark-theme-variables",
                this.isDarkMode
            );
            const themeToggler = this.$refs.themeToggler;
            themeToggler.querySelectorAll("span").forEach((span) => {
                span.classList.toggle("active");
            });
        },
    },
    mounted() {
        this.fetchProfileInfo();
        if (document.body.classList.contains("dark-theme-variables")) {
            this.isDarkMode = true;
            const themeToggler = this.$refs.themeToggler;
            themeToggler.querySelectorAll("span").forEach((span) => {
                span.classList.toggle("active");
            });
        }
    },
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
}

.dark-theme-variables {
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --clr-primary: #bb86fc;
    --clr-danger: #cf6679;
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
    overflow: hidden;
    font-size: 0.88rem;
    user-select: none;
    overflow-x: hidden;
    background: var(--clr-color-background);
    color: var(--clr-dark);
}

.container {
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
}

a {
    color: var(--clr-dark);
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
    margin-top: 20px;
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

.top-bar {
    display: flex;
    gap: 1rem;
    align-items: center;
    justify-content: end;
}

.date {
    display: flex;
    align-items: center;
    background-color: var(--clr-white);
    border-radius: 0.9rem;
    padding: 9px;
    margin-top: 9px;
}

.date input {
    flex-grow: 1;
    background-color: transparent;
    border: none;
    outline: none;
    color: var(--clr-dark);
    padding: 0 10px;
    max-width: 400px;
}

.date button {
    padding: 0.5rem 1rem;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border-radius: 1rem;
    cursor: pointer;
    margin-left: 5px;
}

.date button:hover {
    background-color: var(--clr-primary-variant);
    transition: 0.4s ease-in;
}

.profile-menu {
    position: relative;
    display: flex;
    align-items: center;
    cursor: pointer;
}

.theme-toggler {
    background-color: var(--clr-white);
    display: flex;
    justify-content: space-between;
    height: 1.7rem;
    width: 3.1rem;
    cursor: pointer;
    border-radius: 8px;
    margin-right: 20px;
}

.theme-toggler span {
    font-size: 1rem;
    width: 50%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.theme-toggler span.active {
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border-radius: 8px;
}

.profile-picture {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 2px solid var(--clr-primary);
    cursor: pointer;
    transition: box-shadow 0.3s ease, transform 0.3s ease;
}

.profile-picture:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transform: scale(1.05);
}

.dropdown-menu {
    position: absolute;
    top: 50px;
    right: 0;
    background-color: var(--clr-white);
    border: 1px solid #ddd;
    border-radius: 0.5rem;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    list-style: none;
    padding: 10px 0;
    z-index: 1000;
    width: 150px;
    animation: fadeIn 0.3s ease;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: opacity 0.3s ease, transform 0.3s ease, visibility 0.3s ease;
}

.dropdown-menu.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown-menu li {
    padding: 10px 15px;
    cursor: pointer;
    transition: background-color 0.3s ease, color 0.3s ease;
}

.dropdown-menu li:hover {
    background-color: var(--clr-primary);
    color: var(--clr-white);
}

/* Adding a subtle fade-in animation */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Responsive Design */
@media screen and (max-width: 1200px) {
    input {
        width: 100%;
    }
}

@media screen and (max-width: 768px) {
    .container {
        width: 100%;
        grid-template-columns: repeat(1, 1fr);
    }

    input {
        width: auto !important;
        max-width: 100%;
        min-width: 200px;
    }

    .date {
        display: flex;
        flex-direction: column;
        align-items: stretch;
    }

    .date button {
        margin-top: 10px;
        width: 100%;
    }
}

@media screen and (max-width: 500px) {
    input {
        width: 100%;
        font-size: 0.75rem;
    }

    .date {
        padding: 5px;
    }

    .date button {
        font-size: 0.75rem;
        padding: 0.4rem 0.8rem;
    }
}
</style>
