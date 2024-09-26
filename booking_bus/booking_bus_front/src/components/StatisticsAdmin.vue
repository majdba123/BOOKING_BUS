<template>
    <div>
        <div class="container">
            <div class="portfolio">
                <div class="card" id="storageCard">
                    <div class="card-title">User</div>
                    <div class="card-icon">
                        <i class="material-icons">person</i>
                    </div>
                    <div class="card-data">{{ all_user }}</div>
                    <hr />
                </div>
                <div class="card" id="loveCard">
                    <div class="card-title">Company</div>
                    <div class="card-icon">
                        <i class="material-icons">apartment</i>
                    </div>
                    <div class="card-data">{{ all_company }}</div>
                    <hr />
                </div>
                <div class="card" id="gameCard">
                    <div class="card-title">DriveF</div>
                    <div class="card-icon">
                        <i class="material-icons">group</i>
                    </div>
                    <div class="card-data">{{ all_drivers }}</div>
                    <div class="card-hint"></div>
                </div>
            </div>
            <small>Last 24 Hours</small>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    name: "StatisticsCompany",
    data() {
        return {
            all_company: 0,
            all_user: 0,
            all_drivers: 0,
            salesOffset: 0,
            expensesOffset: 0,
            incomeOffset: 0,
            circumference: 2 * Math.PI * 30,
        };
    },
    methods: {
        fetchData() {
            const accessToken = window.localStorage.getItem("access_token");

            axios
                .get("http://127.0.0.1:8000/api/admin/dashboard_Admin", {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                })
                .then((response) => {
                    const data = response.data;
                    this.all_company = data.all_company || 0;
                    this.all_user = data.all_user || 0;
                    this.all_drivers = data.all_drivers || 0;

                    const maxValue = 100;
                    this.salesPercentage = Math.min(
                        100,
                        (this.all_company / maxValue) * 100
                    );
                    this.expensesPercentage = Math.min(
                        100,
                        (this.all_user / maxValue) * 100
                    );
                    this.incomePercentage = Math.min(
                        100,
                        (this.all_drivers / maxValue) * 100
                    );

                    this.salesOffset =
                        this.circumference -
                        (this.circumference * this.salesPercentage) / 100;
                    this.expensesOffset =
                        this.circumference -
                        (this.circumference * this.expensesPercentage) / 100;
                    this.incomeOffset =
                        this.circumference -
                        (this.circumference * this.incomePercentage) / 100;
                })
                .catch((error) => {
                    console.error("Error fetching data:", error);
                });
        },
    },
    mounted() {
        this.fetchData();
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

    --box-shadow: 0 2rem 3rem var(--clr-light);
    --circle-radius: 30px;
    --circle-diameter: calc(var(--circle-radius) * 2);
    --circle-circumference: calc(2 * var(--circle-radius) * 3.14159);

    --font-size-small: 0.88rem;
    --font-size-medium: 1.2rem;
    --font-size-large: 1.6rem;

    --padding-small: 0.5rem;
    --padding-medium: 1.8rem;
    --padding-large: 40px;

    --transition-duration: 0.3s;
    --transition-ease: ease;
}

body {
    font-family: "Roboto", sans-serif;
    width: 100%;
    height: 100%;
    overflow: hidden;
    font-size: var(--font-size-small);
    user-select: none;
    overflow-x: hidden;
    background: var(--clr-color-background);
}

.container {
    display: grid;
    width: 100%;
    gap: var(--padding-medium);
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
}

.insights {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: var(--padding-small);
    padding: var(--card-padding);
}

.insights > div {
    background-color: var(--clr-white);
    padding: var(--card-padding);
    border-radius: var(--card-border-radius);
    margin-top: var(--padding-small);
    box-shadow: var(--box-shadow);
    transition: box-shadow var(--transition-duration) var(--transition-ease);
}

.insights > div:hover {
    box-shadow: none;
}

.insights > div span {
    background: var(--clr-primary);
    padding: var(--padding-small);
    border-radius: 50%;
    color: var(--clr-white);
    font-size: 2rem;
}

.insights > div.expenses span {
    background: var(--clr-danger);
}

.insights > div.income span {
    background: var(--clr-success);
}

.insights > div .middle {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.insights > div .middle h1 {
    font-size: var(--font-size-large);
    color: var(--clr-dark);
}

.insights .progress {
    position: relative;
    height: var(--circle-diameter);
    width: var(--circle-diameter);
    border-radius: 50%;
}

.insights svg {
    height: 100%;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
}

.insights svg circle {
    fill: none;
    stroke-width: 5;
    stroke-dasharray: var(--circle-circumference);
    transform: rotate(-90deg);
    transform-origin: 50% 59.5%;
}

.insights svg circle.background-circle {
    stroke: var(--clr-info-light);
}

.insights svg circle.sales-circle {
    stroke: var(--clr-primary);
}

.insights svg circle.expenses-circle {
    stroke: var(--clr-danger);
}

.insights svg circle.income-circle {
    stroke: var(--clr-success);
}

.insights .progress .number {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: var(--font-size-medium);
    color: var(--clr-dark);
}

@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 14rem;
    }

    .insights {
        padding: var(--padding-large);
        grid-template-columns: repeat(1, 1fr);
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

    .insights {
        padding: var(--padding-large);
        grid-template-columns: repeat(1, 1fr);
    }
}
</style>
