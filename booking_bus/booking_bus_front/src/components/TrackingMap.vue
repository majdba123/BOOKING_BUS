<template>
    <div id="app">
        <div id="map-container" :class="{ 'map-loaded': shouldDisplayMap }">
            <div id="map" v-show="shouldDisplayMap"></div>
            <div class="no-route-message" v-if="!shouldDisplayMap">
                <p>Select Trip To Display in Map</p>
            </div>
            <div class="no-route-message" v-if="shouldDisplayMap && !hasBus">
                <p>Select Bus To Trucking</p>
            </div>
        </div>
    </div>
</template>

<script>
/* global google */
import { loadGoogleMaps } from "@/utils/googleMapsLoader";

export default {
    name: "TrackingMap",
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
        latbus: {
            type: Number,
            default: null,
        },
        longbus: {
            type: Number,
            default: null,
        },
    },
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
            busMarker: null,
            lastPosition: null,
            busPath: null,
        };
    },
    computed: {
        shouldDisplayMap() {
            return (
                this.fromlat &&
                this.fromlong &&
                this.tolat &&
                this.tolong &&
                !isNaN(parseFloat(this.fromlat)) &&
                !isNaN(parseFloat(this.fromlong)) &&
                !isNaN(parseFloat(this.tolat)) &&
                !isNaN(parseFloat(this.tolong))
            );
        },
        hasBus() {
            return this.latbus !== null && this.longbus !== null;
        },
    },
    async mounted() {
        try {
            await loadGoogleMaps();
            this.initMap();
        } catch (error) {
            console.error("Unable to initialize Google Maps:", error);
        }
    },
    watch: {
        fromlat() {
            this.updateMap();
        },
        fromlong() {
            this.updateMap();
        },
        tolat() {
            this.updateMap();
        },
        tolong() {
            this.updateMap();
        },
        latbus(newLat) {
            if (newLat !== null && this.longbus !== null && this.map) {
                this.updateBusPosition(newLat, this.longbus);
            }
        },
        longbus(newLng) {
            if (newLng !== null && this.latbus !== null && this.map) {
                this.updateBusPosition(this.latbus, newLng);
            }
        },
    },

    methods: {
        updateMap() {
            if (!this.shouldDisplayMap || typeof google === "undefined") {
                return;
            }

            if (this.map && this.directionsService && this.directionsRenderer) {
                this.calculateAndDisplayRoute();
            } else {
                this.initMap();
            }
        },
        updateBusPosition(lat, lng) {
            const newLatLng = new google.maps.LatLng(lat, lng);
            if (this.busMarker) {
                this.animateMarker(newLatLng);
                this.drawBusPath();
            } else {
                this.addBusMarker(lat, lng);
            }
        },
        animateMarker(newLatLng) {
            if (!this.lastPosition) {
                this.lastPosition = newLatLng;
                return;
            }
            const duration = 2000;
            const easeOutQuad = (t) => t * (2 - t);
            const startTime = performance.now();
            const animate = (currentTime) => {
                const elapsedTime = currentTime - startTime;
                const progress = Math.min(elapsedTime / duration, 1);
                const easingProgress = easeOutQuad(progress);
                const interpolatedLat =
                    this.lastPosition.lat() +
                    easingProgress *
                        (newLatLng.lat() - this.lastPosition.lat());
                const interpolatedLng =
                    this.lastPosition.lng() +
                    easingProgress *
                        (newLatLng.lng() - this.lastPosition.lng());
                this.busMarker.setPosition(
                    new google.maps.LatLng(interpolatedLat, interpolatedLng)
                );
                if (progress < 1) {
                    requestAnimationFrame(animate);
                } else {
                    this.lastPosition = newLatLng;
                }
            };
            requestAnimationFrame(animate);
        },
        drawBusPath() {
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlong);
            const busLat = parseFloat(this.latbus);
            const busLng = parseFloat(this.longbus);

            if (
                isNaN(fromLat) ||
                isNaN(fromLng) ||
                isNaN(busLat) ||
                isNaN(busLng)
            ) {
                return;
            }

            const request = {
                origin: { lat: fromLat, lng: fromLng },
                destination: { lat: busLat, lng: busLng },
                travelMode: google.maps.TravelMode.DRIVING,
            };

            if (this.busPath) {
                this.busPath.setMap(null);
            }

            this.directionsService.route(request, (result, status) => {
                if (status === google.maps.DirectionsStatus.OK) {
                    this.busPath = new google.maps.Polyline({
                        path: result.routes[0].overview_path,
                        geodesic: true,
                        strokeColor: "#FF5733",
                        strokeOpacity: 0.8,
                        strokeWeight: 4,
                        map: this.map,
                    });
                }
            });
        },
        initMap() {
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlong);

            if (isNaN(fromLat) || isNaN(fromLng) || typeof google === "undefined") {
                return;
            }

            this.map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: fromLat, lng: fromLng },
                zoom: 7,
                mapTypeId: "roadmap",
            });
            this.directionsService = new google.maps.DirectionsService();
            this.directionsRenderer = new google.maps.DirectionsRenderer({
                map: this.map,
                suppressMarkers: true,
            });

            this.calculateAndDisplayRoute();
        },
        calculateAndDisplayRoute() {
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlong);
            const toLat = parseFloat(this.tolat);
            const toLng = parseFloat(this.tolong);

            if (
                isNaN(fromLat) ||
                isNaN(fromLng) ||
                isNaN(toLat) ||
                isNaN(toLng)
            ) {
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

                    if (this.hasBus) {
                        this.addBusMarker(this.latbus, this.longbus);
                    }
                }
            });
        },

        addBusMarker(lat, lng) {
            if (lat === null || lng === null) {
                return;
            }

            this.busMarker = new google.maps.Marker({
                position: { lat, lng },
                map: this.map,
                icon: {
                    url: "https://img.icons8.com/color/48/000000/bus.png",
                    scaledSize: new google.maps.Size(30, 30),
                },
            });

            this.lastPosition = new google.maps.LatLng(lat, lng);
            this.drawBusPath();
        },
    },
};
</script>

<style scoped>
#map-container {
    position: relative;
    width: 100%;
    height: 600px;
}

#map {
    width: 100%;
    height: 100%;
    opacity: 0;
    transition: opacity 1s ease-in-out;
}

.map-loaded #map {
    opacity: 1;
}

.no-route-message {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: rgba(255, 255, 255, 0.8);
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    font-size: 18px;
}

.bus-marker {
    animation: bounce 1s infinite;
}

@keyframes bounce {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-10px);
    }
}
</style>
