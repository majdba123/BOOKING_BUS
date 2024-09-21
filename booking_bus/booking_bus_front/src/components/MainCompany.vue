<template>
    <main>
        <HeaderCompany2 />
        <StatisticsCompany />
        <!-- End insights -->

        <!-- Start recent orders -->
    </main>
</template>
<script>
import store from "@/store";
import StatisticsCompany from "./StatisticsCompany.vue";
import HeaderCompany2 from "./HeaderCompany2.vue";

export default {
    name: "MainCompany",
    data() {
        return {
            x: store.state.x,
        };
    },
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
    mounted() {},
    components: { StatisticsCompany, HeaderCompany2 },
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

    --box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
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
    background: var(--clr-color-background);
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

.profile-photo img {
    width: 2.8rem;
    height: 2.8rem;
    border-radius: 50%;
    overflow: hidden;
}

.text-muted {
    color: var(--clr-info-dark);
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

aside {
    height: 100vh;
    background-color: var(--clr-white);
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
main {
    margin-top: 1.4rem;
    width: 100%;
}

main input {
    background-color: transparent;
    border: 0;
    outline: 0;
    color: var(--clr-dark);
}

main .top-bar {
    display: flex;
    gap: 1rem;
    align-items: center;
}

main .date {
    display: inline-block;
    background-color: var(--clr-white);
    border-radius: 0.9rem;
    padding: 9px;
    margin-top: 9px;
}

main .date button {
    padding: 0.5rem 1rem;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border-radius: 1rem;
    cursor: pointer;
    margin-left: 5px;
}

main .date button:hover {
    background-color: var(--clr-primary-variant);
    transition: 0.4s ease-in;
}

main .insights {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.6rem;
}

main .insights > div {
    background-color: var(--clr-white);
    padding: var(--card-padding);
    border-radius: var(--card-border-radius);
    margin-top: 1rem;
    box-shadow: var(--box-shadow);
    transition: all 0.3s ease;
}

main .insights > div:hover {
    box-shadow: none;
}

main .insights > div span {
    background: coral;
    padding: 0.5rem;
    border-radius: 50%;
    color: var(--clr-white);
    font-size: 2rem;
}

main .insights > div.expenses span {
    background: var(--clr-danger);
}

main .insights > div.income span {
    background: var(--clr-success);
}

main .insights > div .middle {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

main .insights > div .middle h1 {
    font-size: 1.6rem;
}

main h1 {
    color: var(--clr-dark);
}

main .insights h1 {
    color: var(--clr-dark);
}

main .insights h3 {
    color: var(--clr-dark);
}

main .insights p {
    color: var(--clr-dark);
}

main .insights .progress {
    position: relative;
    height: 68px;
    width: 68px;
    border-radius: 50px;
}

main .insights svg {
    height: 100%;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
}

main .insights svg circle.background-circle {
    fill: none;
    stroke: var(--clr-info-light);
    stroke-width: 6;
}

main .insights svg circle.sales-circle {
    fill: none;
    stroke: var(--clr-primary);
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

main .insights svg circle.expenses-circle {
    fill: none;
    stroke: var(--clr-danger);
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

main .insights svg circle.income-circle {
    fill: none;
    stroke: var(--clr-success);
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

main .insights .progress .number {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 1.2rem;
    color: var(--clr-dark);
}

main .recent_orders h1 {
    margin: 18px;
    color: var(--clr-dark);
}

main .recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: var(--card-border-radius);
    padding: var(--card-padding);
    text-align: center;
    box-shadow: var(--box-shadow);
    transition: all 0.3s ease;
    color: var(--clr-dark);
}

main .recent_orders table:hover {
    box-shadow: none;
}

main table thead tr th {
    padding: 15px;
}

main table tbody tr {
    height: 3.8rem;
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
}

main table tbody td {
    height: 3.8rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}

main table tbody tr:last-child td {
    border: none;
}

main .recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
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
        box-shadow: var(--box-shadow);
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
}
</style>
