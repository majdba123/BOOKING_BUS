<template>
    <div class="dashboard">
        <h2>Chart Dashboard</h2>
        <div class="charts-grid">
            <div class="chart-container">
                <canvas id="tripStatusChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="busStatusChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="driverStatusChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="dailyProfitsChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="weeklyProfitsChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="monthlyProfitsChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="reservationChart"></canvas>
            </div>
            <div class="chart-container">
                <canvas id="privateTripsChart"></canvas>
            </div>
        </div>
        <div class="recent-orders">
            <h1>Trips Overview</h1>
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
    name: "DashboardCharts",
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
        this.fetchTripsData();
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
                this.createChart(
                    "tripStatusChart",
                    ["Pending Trip", "Finished Trip", "Finished Going Trip"],
                    [
                        this.dashboardData.pending_trip,
                        this.dashboardData.finished_trip,
                        this.dashboardData.finished_going_trip,
                    ],
                    "pie"
                );
                this.createChart(
                    "busStatusChart",
                    [
                        "Pending Bus Trip",
                        "Finished Bus Trip",
                        "Finished Going Bus Trip",
                    ],
                    [
                        this.dashboardData.pending_bus_trip,
                        this.dashboardData.finished_bus_trip,
                        this.dashboardData.finished_going_bus_trip,
                    ],
                    "pie"
                );
                this.createChart(
                    "driverStatusChart",
                    [
                        "Pending Drivers",
                        "Available Drivers",
                        "Completed Drivers",
                    ],
                    [
                        this.dashboardData.pending_drivers,
                        this.dashboardData.available_drivers,
                        this.dashboardData.completed_driver,
                    ],
                    "pie"
                );
                this.createChart(
                    "reservationChart",
                    [
                        "Pending Reservations",
                        "Completed Reservations",
                        "Out Reservation",
                    ],
                    [
                        this.dashboardData.pending_reservations,
                        this.dashboardData.completed_reservations,
                        this.dashboardData.out_reservation,
                    ],
                    "bar"
                );
                this.createChart(
                    "privateTripsChart",
                    ["In Progress", "Completed", "Canceled"],
                    [
                        this.dashboardData.inProgress_PrivateTrips,
                        this.dashboardData.completed_PrivateTrips,
                        this.dashboardData.canceled_PrivateTrips,
                    ],
                    "bar"
                );
                this.createChart(
                    "dailyProfitsChart",
                    [
                        "Day 1",
                        "Day 2",
                        "Day 3",
                        "Day 4",
                        "Day 5",
                        "Day 6",
                        "Day 7",
                    ],
                    this.dailyProfits,
                    "line",
                    "#007bff"
                );
                this.createChart(
                    "weeklyProfitsChart",
                    ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5"],
                    this.weeklyProfits,
                    "line",
                    "#28a745"
                );
                this.createChart(
                    "monthlyProfitsChart",
                    ["Month 1", "Month 2", "Month 3", "Month 4", "Month 5"],
                    this.monthlyProfits,
                    "line",
                    "#ffc107"
                );
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
        createChart(chartId, labels, data, type, borderColor = null) {
            const ctx = document.getElementById(chartId).getContext("2d");
            new Chart(ctx, {
                type: type,
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: chartId
                                .replace("Chart", "")
                                .replace(/([A-Z])/g, " $1")
                                .trim(),
                            data: data.map((val) => val || 1), // To handle all zero cases
                            backgroundColor: ["#007bff", "#28a745", "#ffc107"],
                            borderColor: borderColor ? borderColor : "#333",
                            fill: type === "line" ? false : true,
                            tension: type === "line" ? 0.1 : 0,
                        },
                    ],
                },
                options: {
                    responsive: true,
                    scales:
                        type !== "pie"
                            ? {
                                  y: { beginAtZero: true },
                              }
                            : undefined,
                    plugins: {
                        legend: {
                            display: type === "pie" ? true : false,
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
    padding: 20px;
}

h2 {
    margin-bottom: 20px;
    text-align: center;
}

.charts-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    width: 100%;
}

.chart-container {
    background-color: #fff;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    padding: 15px;
    border-radius: 8px;
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
    margin-top: 40px;
    width: 100%;
    overflow-x: auto;
}
.recent-orders h1 {
    display: flex;
    justify-content: center;
    margin-bottom: 10px;
}

.recent-orders table {
    background-color: #fff;
    width: 90%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
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
