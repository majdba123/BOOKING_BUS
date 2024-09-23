<template>
    <div>
        <canvas ref="driverChart"></canvas>
        <div class="total-Fav">
            <h3>Total favourite :</h3>
            <p>{{ count_favourite }}</p>
        </div>
    </div>
</template>

<script>
import { Chart } from "chart.js/auto";
import axios from "axios";
import { nextTick } from "vue";

export default {
    name: "RevChArt",
    data() {
        return {
            chartData: [],
            count_favourite: 0,
        };
    },
    mounted() {
        this.fetchChartData();
    },
    methods: {
        fetchChartData() {
            const accessToken = window.localStorage.getItem("access_token");

            axios
                .get("http://127.0.0.1:8000/api/company/dashboard_company", {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                })
                .then((response) => {
                    this.chartData = [
                        {
                            label: "Pending",
                            value: response.data.pending_reservations,
                        },
                        {
                            label: "Completed",
                            value: response.data.completed_reservations,
                        },
                        {
                            label: "Out Reservation",
                            value: response.data.out_reservation,
                        },
                    ];
                    this.count_favourite = response.data.count_favourite;

                    nextTick(() => {
                        this.createChart();
                    });
                })
                .catch((error) => {
                    console.error("Error fetching chart data:", error);
                });
        },
        createChart() {
            const canvas = this.$refs.driverChart;
            if (canvas) {
                const ctx = canvas.getContext("2d");
                if (ctx) {
                    new Chart(ctx, {
                        type: "bar",
                        data: {
                            labels: this.chartData.map((item) => item.label),
                            datasets: [
                                {
                                    label: "Rev",
                                    data: this.chartData.map(
                                        (item) => item.value
                                    ),
                                    backgroundColor: [
                                        "rgba(75, 192, 192, 0.2)",
                                        "rgba(54, 162, 235, 0.2)",
                                        "rgba(255, 99, 132, 0.2)",
                                    ],
                                    borderColor: [
                                        "rgba(75, 192, 192, 1)",
                                        "rgba(54, 162, 235, 1)",
                                        "rgba(255, 99, 132, 1)",
                                    ],
                                    borderWidth: 1,
                                },
                            ],
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                },
                            },
                            plugins: {
                                legend: {
                                    display: true,
                                    position: "top",
                                },
                            },
                        },
                    });
                } else {
                    console.error("Failed to get context of canvas.");
                }
            } else {
                console.error("Canvas element not found.");
            }
        },
    },
};
</script>

<style scoped>
div {
    position: relative;
    height: 400px;
    width: 100%;
}
.total-Fav {
    display: flex;
    justify-content: center;
    margin-top: 20px;
    font-size: 18px;
    font-weight: bold;
}
</style>
