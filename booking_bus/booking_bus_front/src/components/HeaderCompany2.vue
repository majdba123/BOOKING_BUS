<template>
    <main>
        <div class="top-bar">
            <h1>{{ x }}</h1>
            <div class="datetime-container">
                <div class="time">
                    <div class="time-box">
                        {{ currentDateTime.time.split(":")[0] }}
                        <span>hour</span>
                    </div>
                    <div class="time-box">
                        {{ currentDateTime.time.split(":")[1] }}
                        <span>minutes</span>
                    </div>
                    <div class="time-box">
                        {{ currentDateTime.time.split(":")[2] }}
                        <span>seconds</span>
                    </div>
                </div>
            </div>
            <div class="profile-menu">
                <div class="theme-notification-container">
                    <div
                        class="theme-toggler"
                        ref="themeToggler"
                        @click="toggleTheme"
                    >
                        <span class="material-icons active">light_mode</span>
                        <span class="material-icons">dark_mode</span>
                    </div>
                    <div
                        class="notification-icon"
                        @click="toggleNotificationsMenu"
                    >
                        <span class="material-icons">notifications</span>
                        <!-- Notification count badge -->
                        <span
                            v-if="notifications.length"
                            class="notification-badge"
                        >
                            {{ notifications.length }}
                        </span>
                        <div
                            v-if="showNotificationsMenu"
                            class="notifications-dropdown"
                        >
                            <ul>
                                <li
                                    v-for="notification in notifications"
                                    :key="notification.id"
                                >
                                    {{ this.messages }}
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="profile">
                    <div class="info">
                        <p>
                            <b>{{ getCompanyName }}</b>
                        </p>
                    </div>
                    <div class="profile-photo">
                        <photo @click="toggleProfileMenu" />
                        <ul v-if="showProfileMenu" class="dropdown-menu show">
                            <li @click="goToProfile">Go to Profile</li>
                            <li @click="logout">Logout</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
</template>

<script>
import photo from "@/components/photo.vue";
import store from "@/store";
import Pusher from "pusher-js";
export default {
    name: "HeaderCompany2",
    components: { photo },
    data() {
        return {
            messages: "",
            id: null,
            x: store.state.x,
            showProfileMenu: false,
            profileImage: "",
            isDarkMode: false,
            showNotificationsMenu: false,
            notifications: [],
            currentDateTime: {
                date: "",
                time: "",
            },
        };
    },
    methods: {
        initializePusher() {
            Pusher.logToConsole = true;
            const pusher = new Pusher("7342c00647f26084d14f", {
                cluster: "ap2",
                authEndpoint: "/pusher/auth",
                auth: {
                    params: {
                        userId: this.id,
                    },
                },
            });

            const channel = pusher.subscribe(
                `notification-private-channel-${this.id}`
            );
            console.log("Pusher Channel:", channel);

            channel.bind("PrivateNotification", (data) => {
                const notification = data.message;
                this.$store.commit("ADD_NOTIFICATION", notification);
                this.messages = notification;
                console.log("Notification:", this.messages);
                if (this.messages != null) {
                    this.notifications = ["1"];
                }
            });
        },

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
        updateDateTime() {
            const now = new Date();
            this.currentDateTime.date = now.toISOString().split("T")[0];
            this.currentDateTime.time = now.toTimeString().split(" ")[0];
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
            localStorage.setItem(
                "darkMode",
                this.isDarkMode ? "enabled" : "disabled"
            );

            const themeToggler = this.$refs.themeToggler;
            themeToggler
                .querySelector("span:nth-child(1)")
                .classList.toggle("active", !this.isDarkMode);
            themeToggler
                .querySelector("span:nth-child(2)")
                .classList.toggle("active", this.isDarkMode);
        },
        toggleNotificationsMenu() {
            this.showNotificationsMenu = !this.showNotificationsMenu;
            if (this.showNotificationsMenu) {
                setTimeout(() => {
                    const dropdownMenu = this.$el.querySelector(
                        ".notifications-dropdown"
                    );
                    if (dropdownMenu) {
                        dropdownMenu.classList.add("show");
                    }
                }, 10);
            } else {
                const dropdownMenu = this.$el.querySelector(
                    ".notifications-dropdown"
                );
                if (dropdownMenu) {
                    dropdownMenu.classList.remove("show");
                }
            }
        },
        fetchNotifications() {},
    },
    watch() {
        this.messages;
    },
    mounted() {
        this.updateDateTime();
        this.fetchProfileInfo();
        this.fetchNotifications(); // Fetch notifications on mount
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
    font-weight: 450;
    font-size: 2rem;
    margin-top: 20px;
    color: var(--clr-dark);
    letter-spacing: 0.5px;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
}

h2 {
    font-size: 1.4rem;
    color: var(--clr-dark);
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
    justify-content: space-between;
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
main {
    justify-content: space-around;
    padding: 20px;
    border-end-end-radius: 20px;
    border-bottom-left-radius: 20px;
}

.profile-menu {
    display: flex;
    align-items: center;
}

.theme-notification-container {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.theme-toggler {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: var(--clr-light);
    padding: 0.5rem;
    border-radius: 1rem;
    cursor: pointer;
}

.theme-toggler {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: var(--clr-light);
    padding: 0.5rem;
    border-radius: 1rem;
    cursor: pointer;
}

.theme-toggler span {
    font-size: 1.4rem;
    color: var(--clr-warning);
    cursor: pointer;
}

.theme-toggler span.active {
    color: var(--clr-primary);
}

.notification-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    margin-right: 1.2rem;
    position: relative;
    color: var(--clr-dark);
}

.notification-badge {
    position: absolute;
    top: -3px;
    right: -3px;
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border-radius: 50%;
    width: 13px;
    height: 13px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.5rem;
    font-weight: bold;
    z-index: 100;
}
.notification-icon .material-icons {
    font-size: 1.4rem;
    color: var(--clr-dark);
    transition: color 0.3s ease;
}

.notification-icon .material-icons:hover {
    color: var(--clr-primary);
}
.notifications-dropdown {
    position: absolute;
    top: 40px;
    right: 0;
    background-color: var(--clr-white);
    border: 1px solid #ddd;
    border-radius: 0.5rem;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    list-style: none;
    padding: 10px 0;
    z-index: 1000;
    width: 200px;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: opacity 0.3s ease, transform 0.3s ease, visibility 0.3s ease;
}

.notifications-dropdown.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.notifications-dropdown ul {
    margin: 0;
    padding: 0;
    list-style: none;
}

.notifications-dropdown li {
    padding: 10px 15px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.notifications-dropdown li:hover {
    background-color: var(--clr-light);
}
.profile {
    display: flex;
    align-items: center;
}

.info {
    margin-right: 10px;
}

.info p {
    margin-right: 1rem;
    color: var(--clr-dark);
}
.profile-photo {
    position: relative;
    display: flex;
    align-items: center;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    border: 2px solid var(--clr-primary);
    cursor: pointer;
    transition: box-shadow 0.3s ease, transform 0.3s ease;
}

.profile-photo img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    border: 2px solid var(--clr-primary);
    cursor: pointer;
    transition: box-shadow 0.3s ease, transform 0.3s ease;
}

.profile-photo img:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transform: scale(1.05);
}
.dropdown-menu {
    position: absolute;
    top: 60px;
    right: 0;
    background-color: var(--clr-white);
    border: 1px solid #ddd;
    border-radius: 0.5rem;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    list-style: none;
    padding: 10px 0;
    z-index: 1000;
    width: 150px;
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

@keyframes borderColorShiftTop {
    0% {
        border-top-color: yellow;
    }
    50% {
        border-top-color: blue;
    }
    100% {
        border-top-color: yellow;
    }
}

@keyframes borderColorShiftBottom {
    0% {
        border-bottom-color: yellow;
    }
    50% {
        border-bottom-color: blue;
    }
    100% {
        border-bottom-color: yellow;
    }
}

.time-box {
    background: #111111;
    border-radius: 50% 20% / 10% 40%;
    border-bottom: 1px solid yellow; /* This will use the animation */
    border-top: 1px solid yellow; /* This will use the animation */
    animation: borderColorShiftTop 3s infinite alternate,
        borderColorShiftBottom 3s infinite alternate;
    padding: 1rem 1.5rem;
    box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
    font-size: 1.5rem;
    position: relative;
    color: #ffffff;
    text-align: center;
    background: linear-gradient(135deg, #ff4d4d, #72c3ff);
    color: transparent;
    -webkit-background-clip: text;
    background-clip: text;
}
.datetime-container {
    text-align: center;
    font-family: "Arial", sans-serif;
    color: #ffffff;
}

.dateright {
    font-size: 2rem;
    font-weight: bold;
    color: #72c3ff;
    background: linear-gradient(90deg, #72c3ff, #ff4d4d);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
    margin-bottom: 5px;
}
.time {
    display: flex;
    gap: 1rem;
    justify-content: center;
}

.time-box span {
    display: block;
    font-size: 0.8rem;
    font-weight: normal;
    margin-top: 0.5rem;
    color: #c0c0c0;
}
/* Responsive Design */
@media screen and (max-width: 768px) {
    .container {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 100%;
    }

    .top-bar {
        flex-direction: column;
        align-items: stretch;
        gap: 0.5rem;
        margin-top: 0.9rem;
    }

    .profile-menu {
        margin-top: 0.9rem;

        justify-content: center;
    }

    .profile-photo img {
        width: 40px;
        height: 40px;
    }
}

@media screen and (max-width: 500px) {
    h1 {
        font-size: 1.5rem;
    }

    .theme-toggler {
        margin-right: 1rem;
    }

    .time-box {
        padding: 0.5rem 1rem;
        font-size: 1rem;
    }
}
</style>
