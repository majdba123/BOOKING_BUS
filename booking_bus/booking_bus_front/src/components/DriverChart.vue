<!-- src/components/DriverChart.vue -->
<template>
    <div>
        <canvas ref="driverChart"></canvas>
    </div>
</template>

<script>
import { Chart } from "chart.js/auto";

export default {
    name: "DriverChart",
    props: {
        chartData: {
            type: Object,
            required: true,
        },
    },
    mounted() {
        this.createChart();
    },
    methods: {
        createChart() {
            const ctx = this.$refs.driverChart.getContext("2d");
            new Chart(ctx, {
                type: "pie",
                data: this.chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: "top",
                        },
                    },
                },
            });
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
