<template>
    <div>
        <canvas ref="driverChart"></canvas>
    </div>
</template>

<script>
import { Chart } from "chart.js/auto";
import { nextTick } from "vue";

export default {
    name: "DriverChart",
    props: {
        chartData: {
            type: Object,
            required: true,
        },
    },
    mounted() {
        nextTick(() => {
            this.createChart();
        });
    },
    methods: {
        createChart() {
            const canvas = this.$refs.driverChart;
            if (canvas) {
                const ctx = canvas.getContext("2d");
                if (ctx) {
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
</style>
