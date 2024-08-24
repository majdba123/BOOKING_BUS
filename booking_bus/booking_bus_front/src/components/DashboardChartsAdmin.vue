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
            trips: [], // Store trip data here

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

        this.fetchDashboardData();
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

        fetchDashboardData() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/dashboard_company", {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                })
                .then((response) => {
                    this.dashboardData = response.data;
                    this.processProfitsData();
                    this.createCharts();
                })
                .catch((error) => {
                    console.error("Error fetching dashboard data:", error);
                });
        },
        processProfitsData() {
            this.dailyProfits = [100, 200, 150, 300, 250, 400, 350];
            this.weeklyProfits = [1500, 2000, 1800, 2200, 1700];
            this.monthlyProfits = [6000, 8000, 7000, 9000, 8500];
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
                this.dashboardData.pending_trip || 0,
                this.dashboardData.finished_trip || 0,
                this.dashboardData.finished_going_trip || 0,
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
                this.dashboardData.pending_bus_trip || 0,
                this.dashboardData.finished_bus_trip || 0,
                this.dashboardData.finished_going_bus_trip || 0,
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
                this.dashboardData.pending_drivers || 0,
                this.dashboardData.available_drivers || 0,
                this.dashboardData.completed_driver || 0,
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
                this.dashboardData.pending_reservations || 0,
                this.dashboardData.completed_reservations || 0,
                this.dashboardData.out_reservation || 0,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("reservationChart")
                .getContext("2d");
            this.reservationChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: [
                        "Pending Reservations",
                        "Completed Reservations",
                        "Out Reservation",
                    ],
                    datasets: [
                        {
                            label: "Reservations",
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
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                },
            });
        },
        createPrivateTripsChart() {
            let data = [
                this.dashboardData.inProgress_PrivateTrips || 0,
                this.dashboardData.completed_PrivateTrips || 0,
                this.dashboardData.canceled_PrivateTrips || 0,
            ];

            if (data.every((val) => val === 0)) {
                data = [1, 1, 1];
            }

            const ctx = document
                .getElementById("privateTripsChart")
                .getContext("2d");
            this.privateTripsChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: ["In Progress", "Completed", "Canceled"],
                    datasets: [
                        {
                            label: "Private Trips",
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
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                },
            });
        },
        createDailyProfitsChart() {
            const ctx = document
                .getElementById("dailyProfitsChart")
                .getContext("2d");
            this.dailyProfitsChart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: [
                        "Day 1",
                        "Day 2",
                        "Day 3",
                        "Day 4",
                        "Day 5",
                        "Day 6",
                        "Day 7",
                    ],
                    datasets: [
                        {
                            label: "Daily Profits",
                            data: this.dailyProfits,
                            borderColor: "#007bff",
                            fill: false,
                            tension: 0.1,
                        },
                    ],
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                },
            });
        },
        createWeeklyProfitsChart() {
            const ctx = document
                .getElementById("weeklyProfitsChart")
                .getContext("2d");
            this.weeklyProfitsChart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5"],
                    datasets: [
                        {
                            label: "Weekly Profits",
                            data: this.weeklyProfits,
                            borderColor: "#28a745",
                            fill: false,
                            tension: 0.1,
                        },
                    ],
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                },
            });
        },
        createMonthlyProfitsChart() {
            const ctx = document
                .getElementById("monthlyProfitsChart")
                .getContext("2d");
            this.monthlyProfitsChart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: [
                        "Month 1",
                        "Month 2",
                        "Month 3",
                        "Month 4",
                        "Month 5",
                    ],
                    datasets: [
                        {
                            label: "Monthly Profits",
                            data: this.monthlyProfits,
                            borderColor: "#ffc107",
                            fill: false,
                            tension: 0.1,
                        },
                    ],
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                },
            });
        },
    },
};
</script>

<style scoped>
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
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    padding: 15px;
    background-color: #fff;
    margin-bottom: 15px;
}

.recent-orders {
    margin-top: 20px;
    margin-left: 20px;
    width: 100%;
}

.recent-orders h1 {
    margin: 18px;
    color: #363949;
    display: flex;
    justify-content: center;
}

.recent-orders table {
    background-color: #fff;
    width: 90%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1.5rem 2.5rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
    color: #363949;
    margin-bottom: 20px;
}

.recent-orders table:hover {
    box-shadow: none;
}

.recent-orders table thead tr th {
    padding: 10px;
    color: #007bff;
    font-weight: bold;
}

.recent-orders table tbody tr {
    height: 3rem;
    border-bottom: 1px solid #f1f1f1;
    color: #677483;
}

.recent-orders table tbody td {
    padding: 8px;
    border-bottom: 1px solid #f1f1f1;
}

.recent-orders table tbody tr:last-child td {
    border-bottom: none;
}

.recent-orders table tbody td.warning {
    color: #ffbb55;
    font-weight: bold;
}

.recent-orders table tbody td.primary {
    color: #007bff;
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
