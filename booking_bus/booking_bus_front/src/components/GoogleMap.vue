<template>
    <div id="map"></div>
</template>

<script>
/* global google */

export default {
    name: "GoogleMap",
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
            start: { lat: 33.5138, lng: 36.2765 }, // Damascus
            end: { lat: 36.2021, lng: 37.1343 }, // Aleppo
        };
    },
    mounted() {
        this.initMap();
    },
    methods: {
        initMap() {
            this.map = new google.maps.Map(document.getElementById("map"), {
                center: this.start,
                zoom: 7,
            });

            this.directionsService = new google.maps.DirectionsService();
            this.directionsRenderer = new google.maps.DirectionsRenderer();

            this.directionsRenderer.setMap(this.map);
            this.calculateAndDisplayRoute();
        },
        calculateAndDisplayRoute() {
            this.directionsService.route(
                {
                    origin: this.start,
                    destination: this.end,
                    travelMode: google.maps.TravelMode.DRIVING,
                },
                (response, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        this.directionsRenderer.setDirections(response);
                    } else {
                        console.error(
                            "Directions request failed due to " + status
                        );
                    }
                }
            );
        },
    },
};
</script>

<style>
#map {
    height: 150px;
    width: 60%;
    border-radius: 20px;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}
</style>
