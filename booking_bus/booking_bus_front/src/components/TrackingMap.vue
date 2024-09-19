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
    mounted() {
        this.loadGoogleMapsScript();
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
            if (newLat !== null && this.longbus !== null) {
                this.updateBusPosition(newLat, this.longbus);
            }
        },
        longbus(newLng) {
            if (newLng !== null && this.latbus !== null) {
                this.updateBusPosition(this.latbus, newLng);
            }
        },
    },

    methods: {
        updateMap() {
            if (this.shouldDisplayMap) {
                if (
                    this.map &&
                    this.directionsService &&
                    this.directionsRenderer
                ) {
                    this.calculateAndDisplayRoute();
                } else {
                    this.initMap();
                }
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
            const duration = 2000; // 2 second animation for smooth movement
            const easeOutQuad = (t) => t * (2 - t);
            let startTime = performance.now();
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
                console.error(
                    "Invalid latitude or longitude values for path drawing."
                );
                return;
            }

            const request = {
                origin: { lat: fromLat, lng: fromLng },
                destination: { lat: busLat, lng: busLng },
                travelMode: google.maps.TravelMode.DRIVING,
            };

            if (this.busPath) {
                this.busPath.setMap(null); // Remove the existing path if any
            }

            this.directionsService.route(request, (result, status) => {
                if (status === google.maps.DirectionsStatus.OK) {
                    this.busPath = new google.maps.Polyline({
                        path: result.routes[0].overview_path,
                        geodesic: true,
                        strokeColor: "#FF5733", // Improved color
                        strokeOpacity: 0.8,
                        strokeWeight: 4, // Thicker line for better visibility
                        map: this.map,
                    });
                } else {
                    console.error("Directions request failed due to " + status);
                }
            });
        },

        loadGoogleMapsScript() {
            const script = document.createElement("script");
            script.src =
                "https://maps.googleapis.com/maps/api/js?key=AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44&libraries=places,geometry";
            script.async = true;
            script.defer = true;
            document.head.appendChild(script);

            script.onload = () => {
                this.initMap();
            };

            script.onerror = () => {
                console.error("Failed to load Google Maps script");
                setTimeout(this.loadGoogleMapsScript, 3000);
            };
        },
        initMap() {
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlong);

            if (isNaN(fromLat) || isNaN(fromLng)) {
                console.error("Invalid latitude or longitude values");
                return;
            }

            if (typeof google !== "undefined") {
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
            } else {
                console.error("Google Maps not loaded yet");
                setTimeout(this.initMap, 3000);
            }
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
                console.error(
                    "Invalid latitude or longitude values for route calculation."
                );
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
                } else {
                    console.error("Directions request failed due to " + status);
                }
            });
        },

        addBusMarker(lat, lng) {
            if (!lat || !lng) {
                console.error("Invalid bus coordinates:", lat, lng);
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
