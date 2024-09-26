<template>
    <div class="container">
        <!-- Aside section start -->
        <aside ref="sideMenu">
            <!-- Start top -->
            <div class="top">
                <div class="logo">
                    <h2>T<span class="danger">RAVEL</span></h2>
                </div>
                <div class="close" @click="closeMenu">
                    <span class="material-icons" aria-label="Close">close</span>
                </div>
            </div>
            <!-- End top -->

            <!-- Start sidebar -->
            <SidebarCompany />
            <!-- End sidebar -->
        </aside>
        <div class="main-content">
            <main>
                <HeaderCompany />
                <div class="top-bar">
                    <div class="date">
                        <input
                            type="text"
                            placeholder="Search In..."
                            aria-label="Search"
                            v-model="searchQuery"
                        />
                        <button @click="search">Search</button>
                    </div>
                </div>
                <AddBus ref="addBus" />
            </main>
        </div>
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
                <div class="notification-icon" @click="toggleNotificationsMenu">
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
                <div class="profile">
                    <div class="info">
                        <p>
                            <b>{{ getCompanyName }}</b>
                        </p>
                    </div>

                    <div class="profile-photo">
                        <photo @click="toggleProfileMenu" />
                        <ul v-if="showProfileMenu" class="dropdown-menu">
                            <li @click="goToProfile">Go to Profile</li>
                            <li @click="logout">Logout</li>
                        </ul>
                    </div>
                </div>
            </div>
            <!--end top-->

            <!--start driver_chart-->

            <!--start driver_status-->
            <div class="datetime-container">
                <div class="dateright">{{ currentDateTime.date }}</div>
                <div class="time"></div>
            </div>

            <div class="driver_chart">
                <h2>Bus Status</h2>
                <buschart :chartData="buschart" />
            </div>
        </div>
        <!-- Right section end -->
    </div>
</template>

<script>
import Pusher from "pusher-js";
import SidebarCompany from "@/components/SidebarCompany.vue";
import photo from "@/components/photo.vue";
import store from "@/store";
import router from "@/router";
import { mapGetters } from "vuex";
import HeaderCompany from "@/components/HeaderCompany.vue";
import buschart from "@/components/buschart.vue";
import AddBus from "@/components/AddBus.vue";

export default {
    name: "AllDriver",
    components: {
        SidebarCompany,
        AddBus,
        buschart,
        photo,
        HeaderCompany,
    },
    data() {
        return {
            showNotificationsMenu: false,
            notifications: [],
            messages: "",

            x: store.state.x,
            searchQuery: "",
            showProfileMenu: false,
            Driver: [],
            chartData: {
                labels: ["Under Pressure", "Not Working"],
                datasets: [
                    {
                        label: "Driver Workload Status",
                        data: [60, 40],
                        backgroundColor: [
                            "rgba(255, 99, 132, 0.2)",
                            "rgba(75, 192, 192, 0.2)",
                        ],
                        borderColor: [
                            "rgba(255, 99, 132, 1)",
                            "rgba(75, 192, 192, 1)",
                        ],
                        borderWidth: 1,
                    },
                ],
            },
            isDarkMode: false,
            currentDateTime: {
                date: "",
                time: "",
            },
        };
    },

    watch: {
        message(newMessage) {
            this.messages = newMessage;
        },
        searchQuery(newQuery) {
            store.commit("updateSearchQuery", newQuery);
            console.log(store.state.searchQuery);
        },
    },
    computed: {
        ...mapGetters(["getCompanyName"]),
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
        handleResize() {
            const sideMenu = this.$refs.sideMenu;
            if (window.innerWidth > 768) {
                sideMenu.style.display = "block"; // Show sidebar on large screens
            } else {
                sideMenu.style.display = "none"; // Hide sidebar on small screens
            }
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
        checkToken() {
            const token = window.localStorage.getItem("access_token");
            const userType = window.localStorage.getItem("type_user");

            if (token && userType) {
                if (userType === "admin") {
                    router.push("/");
                } else if (userType === "user") {
                    router.push("/");
                }
            }
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
        updateDateTime() {
            const now = new Date();
            this.currentDateTime.date = now.toISOString().split("T")[0];
            this.currentDateTime.time = now.toTimeString().split(" ")[0];
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
        search() {
            console.log("Searching for:", this.searchQuery);
            // Add your search logic here
        },
    },
    mounted() {
        this.checkToken();
        this.handleResize();
        window.addEventListener("resize", this.handleResize);

        this.updateDateTime();

        setInterval(this.updateDateTime, 1000);
        const savedTheme = localStorage.getItem("darkMode");
        if (savedTheme === "enabled") {
            this.isDarkMode = true;
            document.body.classList.add("dark-theme-variables");
        } else {
            this.isDarkMode = false;
            document.body.classList.remove("dark-theme-variables");
        }

        const themeToggler = this.$refs.themeToggler;
        themeToggler
            .querySelector("span:nth-child(1)")
            .classList.toggle("active", !this.isDarkMode);
        themeToggler
            .querySelector("span:nth-child(2)")
            .classList.toggle("active", this.isDarkMode);
    },
    beforeUnmount() {
        window.removeEventListener("resize", this.handleResize);
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
    background: var(--clr-color-background);
    overflow-y: auto;
}

.container {
    background: var(--clr-color-background);
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 19rem;
    margin-left: 0;
    height: 100vh;
    overflow-y: auto;
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
    color: var(--clr-dark);
}

h4 {
    font-size: 0.8rem;
    color: var(--clr-dark);
}

h5 {
    font-size: 0.77rem;
    color: var(--clr-dark);
}

small {
    font-size: 0.75rem;
    color: var(--clr-dark);
}

@keyframes borderColorShift {
    0% {
        border-color: yellow;
    }
    50% {
        border-color: blue;
    }
    100% {
        border-color: yellow;
    }
}

.profile-photo {
    position: relative;
    display: flex;
    align-items: center;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    border: 2px solid yellow;
    animation: borderColorShift 3s infinite;
    cursor: pointer;
    transition: box-shadow 0.3s ease, transform 0.3s ease;
}
.profile-photo img:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transform: scale(1.05);
}
.text-muted {
    color: #7d8da1;
}

.primary {
    color: var(--clr-primary);
}

.success {
    color: var(--clr-success);
}

.danger {
    color: var(--clr-danger);
}

.warning {
    color: var(--clr-warning);
}

/* aside */

@keyframes colorShift {
    0% {
        border-top-color: rgb(0, 0, 255);
        border-bottom-color: rgb(255, 255, 0);
        border-right-color: rgb(128, 0, 128);
    }
    50% {
        border-top-color: rgb(255, 255, 0);
        border-bottom-color: rgb(0, 0, 255);
        border-right-color: rgb(255, 105, 180);
    }
    100% {
        border-top-color: rgb(0, 0, 255);
        border-bottom-color: rgb(255, 255, 0);
        border-right-color: rgb(128, 0, 128);
    }
}

aside {
    height: 100vh;
    background-color: var(--clr-white);
    display: flex;
    flex-direction: column;
    border-radius: 0 2.5rem 2.5rem 0;
    padding: 1rem;
    border-bottom: 3px solid rgb(255, 0, 0);
    border-top: 3px solid rgb(0, 0, 255);
    border-left: 3px solid transparent;
    animation: colorShift 5s infinite;
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
#menu_bar {
    display: none;
}

.top-bar {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.date {
    display: flex;
    align-items: center;
    gap: 1rem;
    background-color: var(--clr-white);
    border-radius: 0.9rem;
    padding: 9px;
    margin-top: 15px;
    margin-bottom: 15px;
    margin-left: 47px;
}

.date input {
    flex: 1;
    width: 773px;
}

.date button {
    padding: 0.5rem 1rem;
    border: none;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    border-radius: 9px;
    cursor: pointer;
}
@media screen and (max-width: 768px) {
    .date input {
        flex: 1;
        width: 190px;
    }
}
@keyframes gradientAnimation {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.date button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s ease;
}

/* Main section styles */
/*
          start right side
  ***************************** */
.right {
    padding: 1rem;
    border-radius: 2rem 0 0 2rem;
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.right .top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.right .top button {
    background: var(--clr-primary);
    border: none;
    border-radius: 0.5rem;
    color: var(--clr-white);
    padding: 0.5rem 1rem;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s;
}

.right .top button:hover {
    background-color: var(--clr-primary-variant);
}

.right .theme-toggler {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: var(--clr-light);
    padding: 0.5rem;
    border-radius: 1rem;
    cursor: pointer;
}

.right .theme-toggler span {
    font-size: 1.4rem;
    color: var(--clr-warning);
    cursor: pointer;
}

.right .theme-toggler span.active {
    color: var(--clr-primary);
}
.right .profile {
    position: relative;
    display: flex;
    align-items: center;
    cursor: pointer;
}

.right .profile .info p {
    margin-right: 1rem;
    color: var(--clr-dark);
}

.right .driver_chart {
    background: var(--clr-white);
    padding: 1.5rem;
    border-radius: 0.8rem;
    box-shadow: 0 1rem 2rem rgba(132, 139, 200, 0.15);
}

.right .driver_chart h2 {
    display: flex;
    justify-content: center;
    color: var(--clr-dark);
    margin-bottom: 1rem;
    font-size: 1.2rem;
    align-items: center;
}

.right .driver_chart {
    padding: 0.5rem;
}

.p {
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
    color: var(--clr-primary);
}
.driver_status {
    background: var(--clr-white);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    text-align: center;
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
.theme-notification-container {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.driver_status h2 {
    color: var(--clr-dark);
    margin-bottom: 14px;
}

.driver_status .statuses {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.driver_status .status {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    gap: 1rem;
}

.driver_status .status .info {
    display: flex;
    justify-content: center;
    gap: 0.5rem;
}

.driver_status .status .info p {
    margin: 0;
    color: var(--clr-dark);
}
/* Styling for datetime container */
@keyframes borderShift {
    0% {
        border-image-source: linear-gradient(to right, yellow, blue);
    }
    50% {
        border-image-source: linear-gradient(to left, yellow, blue);
    }
    100% {
        border-image-source: linear-gradient(to right, yellow, blue);
    }
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

.time-box {
    background: #111111;
    border-radius: 50% 20% / 10% 40%;
    border-bottom: 1px solid yellow;
    border-top: 1px solid yellow;
    animation: borderColorShift 3s infinite;
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

.time-box span {
    display: block;
    font-size: 0.8rem;
    font-weight: normal;
    margin-top: 0.5rem;
    color: #c0c0c0;
}
/* Select styling */
select {
    padding: 10px;
    border: 1px solid var(--clr-primary);
    border-radius: 5px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    font-size: 0.88rem;
    outline: none;
    transition: border-color 0.3s;
}

select:focus {
    border-color: var(--clr-primary-variant);
}
.dropdown-menu {
    position: absolute;
    top: 50px;
    right: 0;
    background-color: var(--clr-white);
    border: 1px solid var(--clr-info-light);
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

/* Delete button styling */
.delete-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    border: 1px solid var(--clr-danger);
    background-color: var(--clr-white);
    color: var(--clr-danger);
}

.delete-btn:hover {
    background-color: var(--clr-danger);
    color: var(--clr-white);
}

/**********
  media query
  ********** */
@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 18rem;
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
    .map-container {
        margin: 30px;
    }

    aside {
        position: fixed;
        width: 18rem;
        z-index: 3;
        background-color: var(--clr-white);
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
        background-color: var(--clr-white);
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
        color: var(--clr-dark);
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
        background-color: var(--clr-primary);
        color: var(--clr-white);
        border-radius: 10px;
    }
    #menu_bar {
        display: block;
        background: var(--clr-primary);
        border: none;
        border-radius: 0.5rem;
        color: var(--clr-white);
        padding: 0.5rem;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    #menu_bar:hover {
        background-color: var(--clr-primary-variant);
    }
}
</style>
