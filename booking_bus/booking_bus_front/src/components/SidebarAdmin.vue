<template>
    <div class="sidebar">
        <RouterLink
            to="AdminPage"
            @click="selectOption('Dashboard')"
            :class="{ active: selectedOption === 'Dashboard' }"
        >
            <span class="material-icons" aria-label="Dashboard">grid_view</span>
            <h3>Dashboard</h3>
        </RouterLink>

        <RouterLink
            to="AllCompany"
            @click="selectOption('Company')"
            :class="{ active: selectedOption === 'Company' }"
        >
            <span class="material-icons" aria-label="Customers"
                >person_outline</span
            >
            <h3>Company</h3>
        </RouterLink>

        <router-link
            to="AllPath2"
            @click="selectOption('Path')"
            :class="{ active: selectedOption === 'Path' }"
        >
            <span class="material-icons" aria-label="Analytics">timeline</span>
            <h3>Path</h3>
        </router-link>

        <router-link
            to="AllBus2"
            @click="selectOption('Bus')"
            :class="{ active: selectedOption === 'Bus' }"
        >
            <span class="material-icons" aria-label="Products"
                >directions_bus</span
            >
            <h3>Bus</h3>
        </router-link>

        <router-link
            to="AllTrip2"
            @click="selectOption('Trip')"
            :class="{ active: selectedOption === 'Trip' }"
        >
            <span class="material-icons" aria-label="Analytics">route</span>
            <h3>Trip</h3>
        </router-link>
        <router-link
            to="AllRating"
            @click="selectOption('Rate')"
            :class="{ active: selectedOption === 'Rate' }"
        >
            <span class="material-icons" aria-label="Rate">star</span>
            <h3>Rate</h3>
            <span class="msg_count">14</span>
        </router-link>

        <router-link to="AllBreak">
            <span class="material-icons" aria-label="Analytics">pin_drop</span>
            <h3>Break</h3>
        </router-link>

        <router-link
            to="PrivateTrip"
            @click="selectOption('PrivateTrip')"
            :class="{ active: selectedOption === 'PrivateTrip' }"
        >
            <span class="material-icons" aria-label="Products">commute</span>
            <h3>Private Trip</h3>
        </router-link>
        <router-link
            to="AllFavourite"
            @click="selectOption('Favourite')"
            :class="{ active: selectedOption === 'Favourite' }"
        >
            <span class="material-icons" aria-label="Products">favorite</span>
            <h3>Favourite</h3>
        </router-link>

        <router-link
            to="ProfileCompany"
            @click="selectOption('Profile')"
            :class="{ active: selectedOption === 'Profile' }"
        >
            <span class="material-icons" aria-label="Products">person</span>
            <h3>Profile</h3>
        </router-link>
        <router-link
            to="AllReservation"
            @click="selectOption('Reservation')"
            :class="{ active: selectedOption === 'Reservation' }"
        >
            <span class="material-icons" aria-label="Products">person</span>
            <h3>Reservation</h3>
        </router-link>
        <router-link
            to="AllPolices"
            @click="selectOption('AllPolices')"
            :class="{ active: selectedOption === 'AllPolices' }"
        >
            <span class="material-icons" aria-label="Analytics"
                >description</span
            >
            <h3>Polices</h3>
        </router-link>
        <a @click="logout()" :class="{ active: selectedOption === 'Logout' }">
            <span class="material-icons" aria-label="Logout">logout</span>
            <h3>Logout</h3>
        </a>
    </div>
</template>

<script>
import router from "@/router";
import store from "@/store";
import axios from "axios";

export default {
    name: "SideBarAdmin",
    data() {
        return {
            selectedOption: "Dashboard",
        };
    },
    methods: {
        logout() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/logout",
                headers: { Authorization: `Bearer ${token}` },
            }).then(function (response) {
                if (response.status == 200) {
                    console.log(response);
                    window.alert("Logout successful");
                    window.localStorage.setItem(
                        "access_token",
                        response.data.access_token
                    );
                    router.push("/");
                }
            });
        },

        selectOption(option) {
            this.selectedOption = option;
            console.log("Selected Option:", this.selectedOption);
            store.state.x = this.selectedOption;
        },
    },
};
</script>

<style>
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
    overflow: hidden;
    font-size: 0.88rem;
    user-select: none;
    overflow-x: hidden;
    background: #f6f6f9;
}

.container {
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
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

aside {
    position: sticky;
    top: 0;
    width: 14rem;
    background-color: #fff;
    padding: 1rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    margin-top: 1rem;
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

aside .sidebar {
    display: flex;
    flex-direction: column;
    height: calc(100vh - 5rem);
    position: relative;
}

aside h3 {
    font-weight: 400;
}

aside .sidebar a {
    display: flex;
    align-items: center;
    margin-left: 2rem;
    color: #7d8da1;
    height: 2.7rem;
    text-decoration: none;
    gap: 1rem;
    transition: all 0.1s ease-in;
}

aside .sidebar a span {
    font-size: 1.6rem;
    transition: all 0.1s ease-in;
}

aside .sidebar a:last-child {
    position: absolute;
    bottom: 1rem;
    width: 100%;
}

aside .sidebar a.active {
    background: rgba(132, 139, 200, 0.18);
    color: #7380ec;
    margin-left: 0;
}

aside .sidebar a.active::before {
    content: "";
    width: 6px;
    height: 100%;
    background-color: #7380ec;
}

aside .sidebar a:hover {
    color: #7380ec;
    cursor: pointer;
}

aside .top .close span {
    display: none;
}

aside .sidebar a:hover span {
    margin-left: 1rem;
    transition: 0.4s ease;
}

aside .sidebar a span.msg_count {
    background: #ff7782;
    color: #fff;
    padding: 2px 5px;
    font-size: 11px;
    border-radius: 0.4rem;
}

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
