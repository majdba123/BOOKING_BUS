<template>
    <div id="app">
        <div id="map-container" v-if="shouldDisplayMap">
            <div id="map"></div>
        </div>
    </div>
</template>

<script>
/* global google */

export default {
    name: "MapBreak",
    props: {
        lat: {
            type: [Number, String],
            required: false,
            validator: (value) =>
                value !== null && value !== "" && !isNaN(parseFloat(value)),
        },
        long: {
            type: [Number, String],
            required: false,
            validator: (value) =>
                value !== null && value !== "" && !isNaN(parseFloat(value)),
        },
        fromlat: {
            type: [Number, String],
            required: true,
            validator: (value) =>
                value !== null && value !== "" && !isNaN(parseFloat(value)),
        },
        fromlng: {
            type: [Number, String],
            required: true,
            validator: (value) =>
                value !== null && value !== "" && !isNaN(parseFloat(value)),
        },
        tolat: {
            type: [Number, String],
            required: true,
            validator: (value) =>
                value !== null && value !== "" && !isNaN(parseFloat(value)),
        },
        tolng: {
            type: [Number, String],
            required: true,
            validator: (value) =>
                value !== null && value !== "" && !isNaN(parseFloat(value)),
        },
    },
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
            routePath: null,
            selectedMarker: null,
            polyline: null,
        };
    },
    computed: {
        shouldDisplayMap() {
            return (
                this.fromlat &&
                this.fromlng &&
                this.tolat &&
                this.tolng &&
                !isNaN(parseFloat(this.fromlat)) &&
                !isNaN(parseFloat(this.fromlng)) &&
                !isNaN(parseFloat(this.tolat)) &&
                !isNaN(parseFloat(this.tolng))
            );
        },
        shouldDisplayMarker() {
            return (
                this.lat &&
                this.long &&
                !isNaN(parseFloat(this.lat)) &&
                !isNaN(parseFloat(this.long))
            );
        },
    },
    mounted() {
        if (this.shouldDisplayMap) {
            this.loadGoogleMapsScript();
        } else {
            console.error(
                "One or more coordinates are missing or invalid. Map will not be displayed."
            );
        }
    },
    watch: {
        fromlat() {
            if (this.shouldDisplayMap) this.updateMap();
        },
        fromlng() {
            if (this.shouldDisplayMap) this.updateMap();
        },
        tolat() {
            if (this.shouldDisplayMap) this.updateMap();
        },
        tolng() {
            if (this.shouldDisplayMap) this.updateMap();
        },
        lat() {
            if (this.shouldDisplayMarker) this.addMarker();
        },
        long() {
            if (this.shouldDisplayMarker) this.addMarker();
        },
    },
    methods: {
        updateMap() {
            if (this.map && this.directionsService && this.directionsRenderer) {
                this.calculateAndDisplayRoute();
            } else {
                this.initMap();
            }
        },
        loadGoogleMapsScript() {
            const script = document.createElement("script");
            script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44&libraries=places,geometry`;
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
            const fromLng = parseFloat(this.fromlng);

            if (isNaN(fromLat) || isNaN(fromLng)) {
                console.error("Invalid latitude or longitude values");
                return;
            }

            if (typeof google !== "undefined") {
                this.map = new google.maps.Map(document.getElementById("map"), {
                    center: { lat: fromLat, lng: fromLng },
                    zoom: 7,
                    mapTypeId: "roadmap",
                    disableDefaultUI: false,
                    draggable: true,
                    scrollwheel: true,
                    disableDoubleClickZoom: false,
                });

                this.directionsService = new google.maps.DirectionsService();
                this.directionsRenderer = new google.maps.DirectionsRenderer({
                    map: this.map,
                    suppressMarkers: true,
                });

                this.calculateAndDisplayRoute();

                this.map.addListener("click", (event) => {
                    this.handleMapClick(event.latLng);
                });

                if (this.shouldDisplayMarker) {
                    this.addMarker();
                }
            } else {
                console.error("Google Maps not loaded yet");
                setTimeout(this.initMap, 3000);
            }
        },
        calculateAndDisplayRoute() {
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
                    this.routePath = result.routes[0].overview_path;
                    this.enableRouteClicking(this.routePath);
                } else {
                    console.error("Directions request failed due to " + status);
                }
            });
        },
        enableRouteClicking(routePath) {
            if (!routePath || routePath.length === 0) {
                console.error("No route available. Please select a route.");
                this.polyline = null;
                return;
            }

            this.polyline = new google.maps.Polyline({
                path: routePath,
                strokeColor: "#0000FF",
                strokeOpacity: 0.7,
                strokeWeight: 5,
                map: this.map,
            });
        },
        findClosestPointOnPolyline(latLng) {
            if (!this.polyline) {
                console.error("No route available. Please select a route.");
                return latLng;
            }

            let closestPoint = null;
            let minDistance = Infinity;

            this.polyline.getPath().forEach((point) => {
                const distance =
                    google.maps.geometry.spherical.computeDistanceBetween(
                        latLng,
                        point
                    );
                if (distance < minDistance) {
                    minDistance = distance;
                    closestPoint = point;
                }
            });

            return closestPoint || latLng;
        },
        handleMapClick(latLng) {
            if (!this.polyline) {
                console.error("No route available. Please select a route.");
                return;
            }

            if (this.selectedMarker) {
                this.selectedMarker.setMap(null);
            }

            const closestPoint = this.findClosestPointOnPolyline(latLng);

            this.selectedMarker = new google.maps.Marker({
                position: closestPoint,
                map: this.map,
                icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                animation: google.maps.Animation.BOUNCE,
            });

            this.map.setCenter(closestPoint);

            console.log(
                `Selected Coordinates: Latitude: ${closestPoint.lat()}, Longitude: ${closestPoint.lng()}`
            );

            this.$store.state.selectedLat = closestPoint.lat();
            this.$store.state.selectedLng = closestPoint.lng();

            setTimeout(() => {
                if (this.selectedMarker) {
                    this.selectedMarker.setAnimation(null);
                }
            }, 2000);
        },
        addMarker() {
            const lat = parseFloat(this.lat);
            const lng = parseFloat(this.long);

            if (isNaN(lat) || isNaN(lng)) {
                console.error(
                    "Invalid latitude or longitude values for the marker."
                );
                return;
            }

            if (this.map) {
                new google.maps.Marker({
                    position: { lat, lng },
                    map: this.map,
                    icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
                });

                this.map.setCenter({ lat, lng });
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
    border-radius: 9px;
}
</style>
