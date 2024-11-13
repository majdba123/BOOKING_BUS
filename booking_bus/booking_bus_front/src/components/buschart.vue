<template>
    <div>
        <canvas ref="driverChart"></canvas>
    </div>
</template>

<script>
import { Chart } from "chart.js/auto";
import axios from "axios";
import { nextTick } from "vue";

export default {
    name: "BusChart",
    data() {
        return {
            chartData: [],
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
                            value: response.data.pending_Buses,
                        },
                        {
                            label: "Completed",
                            value: response.data.completed_Buses,
                        },
                        {
                            label: "available",
                            value: response.data.availableBuses,
                        },
                    ];
                    nextTick(() => {
                        this.createChart();
                    });
                })
                .catch(() => {});
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
                                    label: "Number Of Bus",
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
                    // console.error("Failed to get context of canvas.");
                }
            } else {
                // console.error("Canvas element not found.");
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
</style>
