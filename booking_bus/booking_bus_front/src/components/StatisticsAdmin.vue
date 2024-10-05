<template>
    <div>
        <div class="container">
            <div class="portfolio">
                <div class="card" id="storageCard">
                    <div class="card-title">Company</div>
                    <div class="card-icon">
                        <i class="material-icons">apartment</i>
                    </div>
                    <div class="card-data">{{ all_company }}</div>
                    <hr />
                </div>
                <div class="card" id="loveCard">
                    <div class="card-title">Drivers</div>
                    <div class="card-icon">
                        <i class="material-icons">group</i>
                    </div>
                    <div class="card-data">{{ all_drivers }}</div>
                    <hr />
                </div>
                <div class="card" id="gameCard">
                    <div class="card-title">User</div>
                    <div class="card-icon">
                        <i class="material-icons">groups</i>
                    </div>
                    <div class="card-data">{{ all_user }}</div>
                    <div class="card-hint"></div>
                </div>
            </div>
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
                .catch(() => {});
        },
    },
    mounted() {
        this.fetchData();
    },
};
</script>

<style scoped>
body {
    padding: 32px;
    background: #ddd;
    font-family: "Roboto", sans-serif;
    margin: 0;
}

h1 {
    color: rgba(255, 255, 255, 0.95);
    text-shadow: 0px 12px 16px rgba(0, 0, 0, 0.2);
    text-align: center;
    margin: 50px 0;
}

.container {
    width: 100%;
}

.portfolio {
    width: 1200px;
    display: flex;
    gap: 1;
    justify-content: space-between;
    margin-top: 1rem;
}

.card {
    border-radius: 9px;
    width: 90%;
    color: var(--clr-dark);
    margin: 16px;
    padding: 24px;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
    position: relative;
    box-sizing: border-box;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.card:hover {
    transform: translateY(-10px);
    box-shadow: 5px 10px 20px rgba(0, 0, 0, 0.2);
}
.card-title {
    font-weight: bold;
    font-size: 1.8rem;
    text-align: left;
    color: white;
}

.card-icon {
    position: absolute;
    top: -24px;
    right: 16px;
    color: white;
    width: 80px;
    height: 80px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 25%;
    box-shadow: 2px 2px 16px rgba(0, 0, 0, 0.15);
}

.card-icon i {
    font-size: 4rem;
}

.card-data {
    font-size: 1.8rem;
    font-weight: 400;
    text-align: right;
    padding-right: 16px;
    color: white;
}
#storageCard {
    background: linear-gradient(60deg, #5e35b1, #039be5); /* Same as the icon */
}

#loveCard {
    background: linear-gradient(60deg, #f50057, #ff8a80); /* Same as the icon */
}

#gameCard {
    background: linear-gradient(60deg, #43a047, #ffeb3b); /* Same as the icon */
}

hr {
    width: 90%;
    margin: 16px auto;
    border-color: white;
}

.card-hint {
    display: flex;
    align-items: center;
    padding-left: 8px;
}

.card-hint i {
    font-size: 1.3rem;
    margin-right: 8px;
}

.card-hint a {
    font-size: 0.9rem;
    font-weight: 300;
}

#storageCard .card-icon {
    background: linear-gradient(60deg, #5e35b1, #039be5);
}

#loveCard .card-icon {
    background: linear-gradient(60deg, #f50057, #ff8a80);
}

#pizzaCard .card-icon {
    background: linear-gradient(60deg, #fb8c00, #ffca29);
}

#gameCard .card-icon {
    background: linear-gradient(60deg, #43a047, #ffeb3b);
}
@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 14rem;
    }
}

/* Mobile Responsive */
@media screen and (max-width: 768px) {
    .portfolio {
        width: 100%;
        display: block;
        grid-template-columns: repeat(1, 1fr);
    }
    .card-icon {
        position: absolute;
        top: -24px;
        right: 16px;
        background: linear-gradient(60deg, #ffa726, #ef6c00);
        color: white;
        width: auto;
        height: auto;
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 25%;
        box-shadow: 2px 2px 16px rgba(0, 0, 0, 0.15);
    }
    .card {
        border-radius: 9px;
        width: 390px;
        background: white;
        margin: 16px;
        padding: 24px;
        box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.1);
        position: relative;
        box-sizing: border-box;
    }
}
</style>
