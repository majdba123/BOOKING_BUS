<template>
    <div class="insights">
        <!-- Start selling -->
        <div class="sales">
            <span class="material-icons" aria-label="Sales">trending_up</span>
            <div class="middle">
                <div class="left">
                    <h3>Company</h3>
                    <h1>\${{ all_company }}</h1>
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
                            :stroke-dashoffset="salesOffset"
                        ></circle>
                    </svg>

                    <div class="number">{{ all_company }}%</div>
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
                    <h3>User</h3>
                    <h1>\${{ all_user }}</h1>
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
                            :stroke-dashoffset="expensesOffset"
                        ></circle>
                    </svg>
                    <div class="number">{{ all_user }}%</div>
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
                    <h3>Drivers</h3>
                    <h1>\${{ all_drivers }}</h1>
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
                            :stroke-dashoffset="incomeOffset"
                        ></circle>
                    </svg>
                    <div class="number">{{ all_drivers }}%</div>
                </div>
            </div>
            <small>Last 24 Hours</small>
        </div>
        <!-- End income -->
    </div>
    <!-- End insights -->
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
            circumference: 2 * Math.PI * 30, // محيط الدائرة
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

                    // حساب النسب المئوية
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

                    // حساب stroke-dashoffset
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

    --box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    --circle-radius: 30px;
    --circle-diameter: calc(var(--circle-radius) * 2);
    --circle-circumference: calc(2 * var(--circle-radius) * 3.14159);
}

body {
    font-family: "Roboto", sans-serif;
    width: 100%;
    height: 100%;
    overflow: hidden;
    font-size: 0.88rem;
    user-select: none;
    overflow-x: hidden;
    background: var(--clr-color-background);
}

.container {
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
}

.insights {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.6rem;
    padding: 1.8rem;
}

.insights > div {
    background-color: var(--clr-white);
    padding: var(--card-padding);
    border-radius: var(--card-border-radius);
    margin-top: 1rem;
    box-shadow: var(--box-shadow);
    transition: box-shadow 0.3s ease;
}

.insights > div:hover {
    box-shadow: none;
}

.insights > div span {
    background: var(--clr-primary);
    padding: 0.5rem;
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
    font-size: 1.6rem;
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
    font-size: 1.2rem;
    color: var(--clr-dark);
}

@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 14rem;
    }

    .insights {
        padding: 40px;
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
        padding: 40px;
        grid-template-columns: repeat(1, 1fr);
    }
}
</style>
