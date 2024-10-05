<template>
    <div id="app">
        <div id="map-container" v-if="shouldDisplayMap">
            <div id="map"></div>
        </div>
        <button @click="prepareToAddBreak" class="styled-button">
            Add Breakpoint
        </button>
        <div v-if="showModal" class="modal">
            <div class="modal-content">
                <h3>Enter Breakpoint Name</h3>
                <input
                    v-model="breakName"
                    type="text"
                    placeholder="Enter name for breakpoint"
                />
                <div class="modal-actions">
                    <button @click="saveBreakName">Save</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
/* global google */

import { useToast } from "vue-toastification";

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
            polyline: null,
            addingBreak: false,
            firstBreakAdded: false,
            toast: useToast(),
            showModal: false,
            breakName: "",
            selectedLatLng: null,
        };
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
    },
    mounted() {
        if (this.shouldDisplayMap) {
            this.loadGoogleMapsScript();
        } else {
            // console.error(
            //     "One or more coordinates are missing or invalid. Map will not be displayed."
            // );
        }
    },
    methods: {
        updateMap() {
            if (this.map && this.directionsService && this.directionsRenderer) {
                this.calculateAndDisplayRoute();
            } else {
                this.initMap();
            }
        },
        saveBreakName() {
            if (!this.breakName) {
                alert("Please enter a name for the breakpoint.");
                return;
            }

            if (this.selectedLatLng) {
                this.$store.state.breakpoints.push({
                    name: this.breakName,
                    lat: this.selectedLatLng.lat(),
                    lng: this.selectedLatLng.lng(),
                });

                const newMarker = new google.maps.Marker({
                    position: this.selectedLatLng,
                    map: this.map,
                    icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                    animation: google.maps.Animation.BOUNCE,
                });

                this.map.setCenter(this.selectedLatLng);

                // إعادة تعيين المتغيرات
                this.addingBreak = false;
                this.breakName = ""; // إعادة تعيين الحقل النصي
                this.showModal = false; // إخفاء المودال

                setTimeout(() => {
                    newMarker.setAnimation(null);
                }, 2000);
            } else {
                this.toast.error("No LatLng selected for the break.");
            }
        },
        // Cancel the naming of the break
        cancelBreakName() {
            this.showModal = false;
            this.breakName = ""; // Clear the input
            this.addingBreak = false; // Reset adding break mode
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
                this.toast.error(
                    "Failed to load Google Maps script, retrying..."
                );
                setTimeout(this.loadGoogleMapsScript, 3000);
            };
        },
        initMap() {
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlng);

            if (isNaN(fromLat) || isNaN(fromLng)) {
                this.toast.error("Invalid latitude or longitude values.");
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

                this.map.addListener("click", (event) => {
                    if (this.addingBreak) {
                        this.handleMapClick(event.latLng);
                    }
                });

                // Automatically add the first breakpoint after the route is displayed
                if (!this.firstBreakAdded) {
                    this.prepareToAddBreak();
                }
            } else {
                this.toast.error("Google Maps not loaded yet");
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
                this.toast.error("Invalid coordinates for route calculation.");
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
                    this.toast.error("Directions request failed: " + status);
                }
            });
        },
        enableRouteClicking(routePath) {
            if (!routePath || routePath.length === 0) {
                this.toast.error("No route available. Please select a route.");
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
        prepareToAddBreak() {
            this.addingBreak = true;
            if (!this.firstBreakAdded) {
                this.toast.info(
                    "Please click a point on the route to add the first breakpoint."
                );
                this.firstBreakAdded = true;
            } else {
                this.toast.info(
                    "Click a point on the route to add another breakpoint."
                );
            }
        },
        handleMapClick(latLng) {
            if (!this.polyline) {
                this.toast.error("No route available. Please select a route.");
                return;
            }

            const closestPoint = this.findClosestPointOnPolyline(latLng);
            this.selectedLatLng = closestPoint;

            // Open the modal for name input
            this.showModal = true;

            const newMarker = new google.maps.Marker({
                position: closestPoint,
                map: this.map,
                icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
                animation: google.maps.Animation.BOUNCE,
            });

            this.map.setCenter(closestPoint);

            this.addingBreak = false;

            setTimeout(() => {
                newMarker.setAnimation(null);
            }, 2000);
        },
        findClosestPointOnPolyline(latLng) {
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
    },
};
</script>

<style scoped>
#map-container {
    height: 550px;
    width: 100%;
}
#map {
    height: 550px;
    width: 100%;
    border-radius: 9px;
}
button {
    width: 100%;
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
button:hover {
    background-color: #0056b3;
}

.modal {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: white;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    z-index: 1000;
    border-radius: 10px;
    width: 300px;
}

.modal-content {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.modal-actions {
    margin-top: 20px;
    display: flex;
    justify-content: space-between;
    width: 100%;
}

.modal-actions button {
    padding: 10px 15px;
    cursor: pointer;
    border: none;
    background-color: #007bff;
    color: white;
    border-radius: 5px;
}

.modal-actions button:hover {
    background-color: #0056b3;
}
</style>
