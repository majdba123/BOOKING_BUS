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
    name: "DisplayMap",
    props: {
        fromlat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        fromlong: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        tolat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        tolong: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        lat: {
            type: [Number, String],
            required: false,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        lng: {
            type: [Number, String],
            required: false,
            validator: (value) => !isNaN(parseFloat(value)),
        },
    },
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
            marker: null,
            routePath: null,
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
            if (typeof google === "undefined") {
                return;
            }

            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlong);
            const toLat = parseFloat(this.tolat);
            const toLng = parseFloat(this.tolong);
            const lat = this.lat ? parseFloat(this.lat) : null;
            const lng = this.lng ? parseFloat(this.lng) : null;

            if (
                isNaN(fromLat) ||
                isNaN(fromLng) ||
                isNaN(toLat) ||
                isNaN(toLng) ||
                (lat !== null && (lng === null || isNaN(lng)))
            ) {
                return;
            }

            this.map = new google.maps.Map(document.getElementById("map"), {
                center: {
                    lat: (fromLat + toLat) / 2,
                    lng: (fromLng + toLng) / 2,
                },
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
                suppressMarkers: true,
            });

            this.calculateAndDisplayRoute(fromLat, fromLng, toLat, toLng);

            if (lat !== null && lng !== null) {
                this.marker = new google.maps.Marker({
                    position: { lat, lng },
                    map: this.map,
                    icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
                });

                this.marker.addListener("click", () => {
                    const infoWindow = new google.maps.InfoWindow({
                        content: `<div><strong>Selected Location</strong></div>`,
                    });
                    infoWindow.open(this.map, this.marker);
                });

                this.map.setCenter({ lat, lng });
            }
        },
        calculateAndDisplayRoute(fromLat, fromLng, toLat, toLng) {
            if (!this.directionsService || !this.directionsRenderer) {
                return;
            }

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
