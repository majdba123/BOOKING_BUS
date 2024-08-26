<template>
    <div>
        <div id="map"></div>
        <button @click="resetMarkers" class="reset-button">Reset Points</button>
    </div>
</template>

<script>
/* global google */
import store from "@/store";
import { useToast } from "vue-toastification";

export default {
    name: "MapPath",
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
            startMarker: null,
            endMarker: null,
            toast: useToast(),
            distance: null, // Variable to store the distance
        };
    },
    mounted() {
        this.initMap();
        this.toast.info("Click on the map to set the start point.");
    },
    methods: {
        initMap() {
            this.map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 34.8021, lng: 38.9968 }, // Center of Syria
                zoom: 7,
            });

            this.directionsService = new google.maps.DirectionsService();
            this.directionsRenderer = new google.maps.DirectionsRenderer();
            this.directionsRenderer.setMap(this.map);

            this.map.addListener("click", (event) => {
                this.handleMapClick(event.latLng);
            });

            if (
                store.state.startLat !== null &&
                store.state.startLng !== null
            ) {
                this.startMarker = new google.maps.Marker({
                    position: {
                        lat: store.state.startLat,
                        lng: store.state.startLng,
                    },
                    map: this.map,
                    label: "A",
                });
                this.map.setCenter({
                    lat: store.state.startLat,
                    lng: store.state.startLng,
                });
            }

            if (store.state.endLat !== null && store.state.endLng !== null) {
                this.endMarker = new google.maps.Marker({
                    position: {
                        lat: store.state.endLat,
                        lng: store.state.endLng,
                    },
                    map: this.map,
                    label: "B",
                });
            }

            if (this.startMarker && this.endMarker) {
                this.calculateAndDisplayRoute();
            }
        },
        handleMapClick(location) {
            const latitude = location.lat();
            const longitude = location.lng();

            if (!this.startMarker) {
                this.startMarker = new google.maps.Marker({
                    position: { lat: latitude, lng: longitude },
                    map: this.map,
                    label: "A",
                });

                store.commit("setStartCoordinates", {
                    lat: latitude,
                    lng: longitude,
                });

                this.toast.success(
                    "Start point selected! Now click to set the end point."
                );
            } else if (!this.endMarker) {
                this.endMarker = new google.maps.Marker({
                    position: { lat: latitude, lng: longitude },
                    map: this.map,
                    label: "B",
                });

                store.commit("setEndCoordinates", {
                    lat: latitude,
                    lng: longitude,
                });

                this.toast.success("End point selected!");
                this.calculateAndDisplayRoute();
            } else {
                this.resetMarkers();
                this.handleMapClick(location);
            }
        },
        calculateAndDisplayRoute() {
            const start = {
                lat: store.state.startLat,
                lng: store.state.startLng,
            };
            const end = {
                lat: store.state.endLat,
                lng: store.state.endLng,
            };

            this.directionsService.route(
                {
                    origin: start,
                    destination: end,
                    travelMode: google.maps.TravelMode.DRIVING,
                },
                (response, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        this.directionsRenderer.setDirections(response);

                        const route = response.routes[0];
                        if (route.legs.length > 0) {
                            const distanceText = route.legs[0].distance.text;
                            // استخراج الرقم فقط من النص
                            this.distance = parseFloat(distanceText);

                            this.toast.success(`Distance: ${this.distance} km`);
                            store.state.distance = this.distance;
                        }
                    } else {
                        console.error(
                            "Directions request failed due to " + status
                        );
                        this.toast.error(
                            "Could not calculate route. Please try again."
                        );
                    }
                }
            );
        },

        resetMarkers() {
            if (this.startMarker) {
                this.startMarker.setMap(null);
                this.startMarker = null;
            }
            if (this.endMarker) {
                this.endMarker.setMap(null);
                this.endMarker = null;
            }
            store.commit("resetCoordinates");
            this.directionsRenderer.setDirections({ routes: [] });
            this.toast.info(
                "Points have been reset! Click on the map to set the start point."
            );
        },
        // Additional methods for user interface enhancements
        resetMap() {
            this.resetMarkers();
            this.toast.info("Map reset. Select new start and end points.");
        },
        validateCoordinates(lat, lng) {
            // Example validation: Ensure coordinates are within Syria's boundaries
            if (lat >= 32 && lat <= 37 && lng >= 35 && lng <= 43) {
                return true;
            }
            this.toast.error(
                "Invalid coordinates! Please select within Syria."
            );
            return false;
        },
        handleConnectionError() {
            this.toast.error(
                "Connection to Google Maps failed. Check your internet connection."
            );
        },
    },
};
</script>

<style>
#map {
    height: 400px;
    width: 100%;
}

.reset-button {
    margin-top: 10px;
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.reset-button:hover {
    background-color: #0056b3;
}

/* Responsive styling for the map */
@media screen and (max-width: 768px) {
    #map {
        height: 300px;
    }
}

@media screen and (max-width: 480px) {
    #map {
        height: 200px;
    }
}
</style>
