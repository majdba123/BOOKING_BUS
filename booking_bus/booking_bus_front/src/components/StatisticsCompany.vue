<template>
    <div class="insights">
        <!-- Start selling -->
        <div class="sales">
            <span class="material-icons" aria-label="Sales">trending_up</span>
            <div class="middle">
                <div class="left">
                    <h3>Total Sales</h3>
                    <h1>$25,024</h1>
                </div>
                <div class="progress">
                    <svg>
                        <circle
                            class="background-circle"
                            r="30"
                            cy="40"
                            cx="40"
                        ></circle>
                        <circle
                            class="sales-circle"
                            r="30"
                            cy="40"
                            cx="40"
                        ></circle>
                    </svg>
                    <div class="number">80%</div>
                </div>
            </div>
            <small>Last 24 Hours</small>
        </div>
        <!-- End selling -->

        <!-- Start expenses -->
        <div class="expenses">
            <span class="material-icons" aria-label="Expenses">local_mall</span>
            <div class="middle">
                <div class="left">
                    <h3>Expenses</h3>
                    <h1>$25,024</h1>
                </div>
                <div class="progress">
                    <svg>
                        <circle
                            class="background-circle"
                            r="30"
                            cy="40"
                            cx="40"
                        ></circle>
                        <circle
                            class="expenses-circle"
                            r="30"
                            cy="40"
                            cx="40"
                        ></circle>
                    </svg>
                    <div class="number">80%</div>
                </div>
            </div>
            <small>Last 24 Hours</small>
        </div>
        <!-- End expenses -->

        <!-- Start income -->
        <div class="income">
            <span class="material-icons" aria-label="Income"
                >stacked_line_chart</span
            >
            <div class="middle">
                <div class="left">
                    <h3>Income</h3>
                    <h1>$25,024</h1>
                </div>
                <div class="progress">
                    <svg>
                        <circle
                            class="background-circle"
                            r="30"
                            cy="40"
                            cx="40"
                        ></circle>
                        <circle
                            class="income-circle"
                            r="30"
                            cy="40"
                            cx="40"
                        ></circle>
                    </svg>
                    <div class="number">80%</div>
                </div>
            </div>
            <small>Last 24 Hours</small>
        </div>
        <!-- End income -->
    </div>
    <!-- End insights -->
</template>
<script>
import store from "@/store";
export default {
    name: "StatisticsCompany",
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

.insights {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.6rem;
}

.insights > div {
    background-color: #fff;
    padding: 1.8rem;
    border-radius: 2rem;
    margin-top: 1rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
}

.insights > div:hover {
    box-shadow: none;
}

.insights > div span {
    background: coral;
    padding: 0.5rem;
    border-radius: 50%;
    color: #fff;
    font-size: 2rem;
}

.insights > div.expenses span {
    background: #ff7782;
}

.insights > div.income span {
    background: #41f1b6;
}

.insights > div .middle {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.insights > div .middle h1 {
    font-size: 1.6rem;
}

h1 {
    color: #363949;
}

.insights h1 {
    color: #363949;
}

.insights h3 {
    color: #363949;
}

.insights p {
    color: #363949;
}

.insights .progress {
    position: relative;
    height: 68px;
    width: 68px;
    border-radius: 50px;
}

.insights svg {
    height: 100%;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
}

.insights svg circle.background-circle {
    fill: none;
    stroke: #e4e9f7;
    stroke-width: 6;
}

.insights svg circle.sales-circle {
    fill: none;
    stroke: #7380ec;
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

.insights svg circle.expenses-circle {
    fill: none;
    stroke: #ff7782;
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

.insights svg circle.income-circle {
    fill: none;
    stroke: #41f1b6;
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

.insights .progress .number {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 1.2rem;
    color: #363949;
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

    .insights {
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

    .insights {
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
