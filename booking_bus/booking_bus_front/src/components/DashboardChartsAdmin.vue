<template>
    <div class="dashboard">
        <h2>Chart Dashboard</h2>
        <div class="charts-grid">
            <div class="chart-trio">
                <div class="chart-container">
                    <canvas id="tripStatusChart"></canvas>
                </div>
                <div class="chart-container">
                    <canvas id="busStatusChart"></canvas>
                </div>
                <div class="chart-container">
                    <canvas id="driverStatusChart"></canvas>
                </div>
            </div>
            <div class="chart-trio">
                <div class="chart-container">
                    <canvas id="dailyProfitsChart"></canvas>
                </div>
                <div class="chart-container">
                    <canvas id="weeklyProfitsChart"></canvas>
                </div>
                <div class="chart-container">
                    <canvas id="monthlyProfitsChart"></canvas>
                </div>
            </div>
            <div class="chart-pair">
                <div class="chart-container">
                    <canvas id="reservationChart"></canvas>
                </div>
                <div class="chart-container">
                    <canvas id="privateTripsChart"></canvas>
                </div>
            </div>
        </div>
        <div class="recent-orders">
            <h1>Name Trips</h1>
            <table>
                <thead>
                    <tr>
                        <th>Trip Name</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Price</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="trip in trips" :key="trip.name">
                        <td>{{ trip.name }}</td>
                        <td>{{ trip.from }}</td>
                        <td>{{ trip.to }}</td>
                        <td>{{ trip.price }}</td>
                        <td
                            :class="{
                                warning: trip.status === 'Pending',
                                primary: trip.status === 'Completed',
                            }"
                        >
                            {{ trip.status }}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script>
import { Chart } from "chart.js";
import axios from "axios";

export default {
    name: "DashboardChartsAdmin",
    data() {
        return {
            trips: [],
            dashboardData: null,
            dailyProfits: [],
            weeklyProfits: [],
            monthlyProfits: [],
            tripStatusChart: null,
            busStatusChart: null,
            driverStatusChart: null,
            reservationChart: null,
            privateTripsChart: null,
            dailyProfitsChart: null,
            weeklyProfitsChart: null,
            monthlyProfitsChart: null,
        };
    },
    mounted() {
        this.fetchTripsData(); // Fetch trips data when component is mounted
        this.loadDashboardData();
    },
    beforeUnmount() {
        this.destroyCharts();
    },
    methods: {
        fetchTripsData() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/all_trips", {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                })
                .then((response) => {
                    this.trips = response.data
                        .map((trip) => ({
                            name: `${trip.path.from} to ${trip.path.to}`,
                            from: trip.path.from,
                            to: trip.path.to,
                            price: parseFloat(trip.price),
                            status: trip.status,
                        }))
                        .sort((a, b) => b.price - a.price);
                })
                .catch((error) => {
                    console.error("Error fetching trips data:", error);
                });
        },

        loadDashboardData() {
            const cachedData = localStorage.getItem("dashboardData");
            const cacheTimestamp = localStorage.getItem(
                "dashboardDataTimestamp"
            );
            const currentTime = new Date().getTime();

            if (
                cachedData &&
                cacheTimestamp &&
                currentTime - cacheTimestamp < 30 * 60 * 1000
            ) {
                // Use cached data
                this.dashboardData = JSON.parse(cachedData);
                this.processProfitsData();
                this.createCharts();
            } else {
                // Fetch new data from API
                this.fetchDashboardData();
            }
        },

        fetchDashboardData() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/admin/dashboard_Admin", {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                })
                .then((response) => {
                    this.dashboardData = {
                        pending_reservations:
                            response.data.pending_reservations || 0,
                        completed_reservations:
                            response.data.completed_reservations || 0,
                        out_reservation: response.data.out_reservation || 0,
                        pending_trip: response.data.pending_trip || 0,
                        finished_trip: response.data.finished_trip || 0,
                        finished_going_trip:
                            response.data.finished_going_trip || 0,
                        pending_bus_trip: response.data.pending_bus_trip || 0,
                        finished_bus_trip: response.data.finished_bus_trip || 0,
                        finished_going_bus_trip:
                            response.data.finished_going_bus_trip || 0,
                        total_profit_pending:
                            response.data.total_profit_pending || 0,
                        total_profit_completed:
                            response.data.total_profit_completed || 0,
                        total_profit_out: response.data.total_profit_out || 0,
                        all_drivers: response.data.all_drivers || 0,
                        pending_drivers: response.data.pending_drivers || 0,
                        available_drivers: response.data.available_drivers || 0,
                        completed_driver: response.data.completed_driver || 0,
                        allBuses: response.data.allBuses || 0,
                        completed_Buses: response.data.completed_Buses || 0,
                        availableBuses: response.data.availableBuses || 0,
                        pending_Buses: response.data.pending_Buses || 0,
                        inProgress_PrivateTrips:
                            response.data.inProgress_PrivateTrips || 0,
                        completed_PrivateTrips:
                            response.data.completed_PrivateTrips || 0,
                        canceled_PrivateTrips:
                            response.data.canceled_PrivateTrips || 0,
                        total_price_completed_PrivateTrips:
                            response.data.total_price_completed_PrivateTrips ||
                            0,
                        count_favourite: response.data.count_favourite || 0,
                        all_user: response.data.all_user || 0,
                        all_company: response.data.all_company || 0,
                    };
                    // Cache the data
                    localStorage.setItem(
                        "dashboardData",
                        JSON.stringify(this.dashboardData)
                    );
                    localStorage.setItem(
                        "dashboardDataTimestamp",
                        new Date().getTime()
                    );
                    this.processProfitsData();
                    this.createCharts();
                })
                .catch((error) => {
                    console.error("Error fetching dashboard data:", error);
                });
        },

        processProfitsData() {
            this.dailyProfits = [
                this.dashboardData.total_profit_pending,
                this.dashboardData.total_profit_completed,
                this.dashboardData.total_profit_out,
            ];
            this.weeklyProfits = [
                this.dashboardData.total_profit_pending,
                this.dashboardData.total_profit_completed,
                this.dashboardData.total_profit_out,
            ];
            this.monthlyProfits = [
                this.dashboardData.total_profit_pending,
                this.dashboardData.total_profit_completed,
                this.dashboardData.total_profit_out,
            ];
        },

        createCharts() {
            if (this.dashboardData) {
                this.createTripStatusChart();
                this.createBusStatusChart();
                this.createDriverStatusChart();
                this.createReservationChart();
                this.createPrivateTripsChart();
                this.createDailyProfitsChart();
                this.createWeeklyProfitsChart();
                this.createMonthlyProfitsChart();
            }
        },

        destroyCharts() {
            if (this.tripStatusChart) this.tripStatusChart.destroy();
            if (this.busStatusChart) this.busStatusChart.destroy();
            if (this.driverStatusChart) this.driverStatusChart.destroy();
            if (this.reservationChart) this.reservationChart.destroy();
            if (this.privateTripsChart) this.privateTripsChart.destroy();
            if (this.dailyProfitsChart) this.dailyProfitsChart.destroy();
            if (this.weeklyProfitsChart) this.weeklyProfitsChart.destroy();
            if (this.monthlyProfitsChart) this.monthlyProfitsChart.destroy();
        },

        createTripStatusChart() {
            let data = [
                this.dashboardData.pending_trip,
                this.dashboardData.finished_trip,
                this.dashboardData.finished_going_trip,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("tripStatusChart")
                .getContext("2d");
            this.tripStatusChart = new Chart(ctx, {
                type: "pie",
                data: {
                    labels: [
                        "Pending Trip",
                        "Finished Trip",
                        "Finished Going Trip",
                    ],
                    datasets: [
                        {
                            data: data,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderWidth: 1,
                            borderColor: "#333",
                            hoverBorderWidth: 3,
                            hoverOffset: 15,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createBusStatusChart() {
            let data = [
                this.dashboardData.pending_bus_trip,
                this.dashboardData.finished_bus_trip,
                this.dashboardData.finished_going_bus_trip,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("busStatusChart")
                .getContext("2d");
            this.busStatusChart = new Chart(ctx, {
                type: "pie",
                data: {
                    labels: [
                        "Pending Bus Trip",
                        "Finished Bus Trip",
                        "Finished Going Bus Trip",
                    ],
                    datasets: [
                        {
                            data: data,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderWidth: 1,
                            borderColor: "#333",
                            hoverBorderWidth: 3,
                            hoverOffset: 15,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createDriverStatusChart() {
            let data = [
                this.dashboardData.pending_drivers,
                this.dashboardData.available_drivers,
                this.dashboardData.completed_driver,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("driverStatusChart")
                .getContext("2d");
            this.driverStatusChart = new Chart(ctx, {
                type: "pie",
                data: {
                    labels: [
                        "Pending Drivers",
                        "Available Drivers",
                        "Completed Drivers",
                    ],
                    datasets: [
                        {
                            data: data,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderWidth: 1,
                            borderColor: "#333",
                            hoverBorderWidth: 3,
                            hoverOffset: 15,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createReservationChart() {
            let data = [
                this.dashboardData.pending_reservations,
                this.dashboardData.completed_reservations,
                this.dashboardData.out_reservation,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("reservationChart")
                .getContext("2d");
            this.reservationChart = new Chart(ctx, {
                type: "pie",
                data: {
                    labels: [
                        "Pending Reservations",
                        "Completed Reservations",
                        "Out Reservations",
                    ],
                    datasets: [
                        {
                            data: data,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderWidth: 1,
                            borderColor: "#333",
                            hoverBorderWidth: 3,
                            hoverOffset: 15,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createPrivateTripsChart() {
            let data = [
                this.dashboardData.inProgress_PrivateTrips,
                this.dashboardData.completed_PrivateTrips,
                this.dashboardData.canceled_PrivateTrips,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("privateTripsChart")
                .getContext("2d");
            this.privateTripsChart = new Chart(ctx, {
                type: "pie",
                data: {
                    labels: [
                        "In Progress Private Trips",
                        "Completed Private Trips",
                        "Canceled Private Trips",
                    ],
                    datasets: [
                        {
                            data: data,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderWidth: 1,
                            borderColor: "#333",
                            hoverBorderWidth: 3,
                            hoverOffset: 15,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createDailyProfitsChart() {
            const ctx = document
                .getElementById("dailyProfitsChart")
                .getContext("2d");
            this.dailyProfitsChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: ["Pending", "Completed", "Out"],
                    datasets: [
                        {
                            label: "Daily Profits",
                            data: this.dailyProfits,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderColor: "#333",
                            borderWidth: 1,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createWeeklyProfitsChart() {
            const ctx = document
                .getElementById("weeklyProfitsChart")
                .getContext("2d");
            this.weeklyProfitsChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: ["Pending", "Completed", "Out"],
                    datasets: [
                        {
                            label: "Weekly Profits",
                            data: this.weeklyProfits,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderColor: "#333",
                            borderWidth: 1,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },

        createMonthlyProfitsChart() {
            const ctx = document
                .getElementById("monthlyProfitsChart")
                .getContext("2d");
            this.monthlyProfitsChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: ["Pending", "Completed", "Out"],
                    datasets: [
                        {
                            label: "Monthly Profits",
                            data: this.monthlyProfits,
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderColor: "#333",
                            borderWidth: 1,
                        },
                    ],
                },
                options: {
                    responsive: true,
                },
            });
        },
    },
};
</script>

<style scoped>
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

.dashboard {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    padding: 20px;
    height: 100vh;
}

h2 {
    margin-bottom: 20px;
    text-align: center;
}

.charts-grid {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.chart-trio,
.chart-pair {
    display: flex;
    justify-content: center;
    gap: 20px;
}

.chart-container {
    flex: 1;
    max-width: 300px;
    min-width: 150px;
    box-shadow: 0px 4px 10px var(--clr-light);
    border-radius: 10px;
    padding: 15px;
    background-color: var(--clr-white);
    margin-bottom: 15px;
}

.recent-orders {
    margin-top: 20px;
    margin-left: 20px;
    width: 100%;
}

.recent-orders h1 {
    margin: 18px;
    color: var(--clr-dark);
    display: flex;
    justify-content: center;
}

.recent-orders table {
    background-color: var(--clr-white);
    width: 90%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1.5rem 2.5rem var(--clr-light);
    transition: all 0.3s ease;
    color: var(--clr-dark);
    margin-bottom: 20px;
}

.recent-orders table:hover {
    box-shadow: none;
}

.recent-orders table thead tr th {
    padding: 10px;
    color: var(--clr-primary);
    font-weight: bold;
}

.recent-orders table tbody tr {
    height: 3rem;
    border-bottom: 1px solid #f1f1f1;
    color: var(--clr-dark-variant);
}

.recent-orders table tbody td {
    padding: 8px;
    border-bottom: 1px solid #f1f1f1;
}

.recent-orders table tbody tr:last-child td {
    border-bottom: none;
}

.recent-orders table tbody td.warning {
    color: var(--clr-warning);
    font-weight: bold;
}

.recent-orders table tbody td.primary {
    color: var(--clr-primary);
    cursor: pointer;
}

@media screen and (max-width: 768px) {
    .chart-trio,
    .chart-pair {
        flex-direction: column;
        align-items: center;
    }
    .chart-container {
        max-width: 100%;
    }
}
</style>
