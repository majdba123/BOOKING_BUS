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
            <div class="profile-menu"></div>
        </div>
    </main>
</template>

<script>
import store from "@/store";
import { mapGetters } from "vuex";

export default {
    name: "HeaderCompany",
    components: {},
    data() {
        return {
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
    computed: {
        ...mapGetters(["getCompanyName"]),
    },
    methods: {
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
    },
    mounted() {
        this.updateDateTime();
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
    margin-top: 1rem;
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
