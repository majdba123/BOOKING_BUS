<template>
    <div id="app">
        <div id="map-container">
            <div id="map"></div>
        </div>
    </div>
</template>

<script>
/* global google */
import { loadGoogleMaps } from "@/utils/googleMapsLoader";

export default {
    name: "MapPrivate",
    props: {
        fromlat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        fromlng: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        tolat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        tolng: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
    },
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
        };
    },
    async mounted() {
        try {
            await loadGoogleMaps();
            this.initMap();
        } catch (error) {
            console.error("Unable to initialize Google Maps:", error);
        }
    },
    methods: {
        initMap() {
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlng);
            const toLat = parseFloat(this.tolat);
            const toLng = parseFloat(this.tolng);

            if (
                isNaN(fromLat) ||
                isNaN(fromLng) ||
                isNaN(toLat) ||
                isNaN(toLng)
            ) {
                return;
            }

            if (typeof google !== "undefined") {
                this.map = new google.maps.Map(document.getElementById("map"), {
                    center: { lat: fromLat, lng: fromLng },
                    zoom: 15,
                    mapTypeId: "roadmap",
                    disableDefaultUI: true,
                    draggable: false,
                    scrollwheel: false,
                    disableDoubleClickZoom: true,
                });

                this.directionsService = new google.maps.DirectionsService();
                this.directionsRenderer = new google.maps.DirectionsRenderer({
                    map: this.map,
                    suppressMarkers: false,
                });

                const request = {
                    origin: { lat: fromLat, lng: fromLng },
                    destination: { lat: toLat, lng: toLng },
                    travelMode: google.maps.TravelMode.DRIVING,
                };

                this.directionsService.route(request, (result, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        this.directionsRenderer.setDirections(result);
                    }
                });
            }
        },
    },
};
</script>

<style scoped>
#map-container {
    position: relative;
    width: 100%;
    height: 400px;
}

#map {
    height: 100%;
    width: 100%;
}
</style>
