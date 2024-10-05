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
    name: "MapTrip",
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
            startMarker: null,
            endMarker: null,
            toast: useToast(),
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

            if (store.state.start && store.state.end) {
                this.startMarker = new google.maps.Marker({
                    position: store.state.start,
                    map: this.map,
                    label: "A",
                });

                this.endMarker = new google.maps.Marker({
                    position: store.state.end,
                    map: this.map,
                    label: "B",
                });

                this.calculateAndDisplayRoute();
            }
        },
        handleMapClick(location) {
            if (!this.startMarker) {
                this.startMarker = new google.maps.Marker({
                    position: location,
                    map: this.map,
                    label: "A",
                });
                store.commit("setStart", location);
                this.toast.success(
                    "Start point selected! Now click to set the end point."
                );
                // console.log("Start point selected:", location.toString());
            } else if (!this.endMarker) {
                this.endMarker = new google.maps.Marker({
                    position: location,
                    map: this.map,
                    label: "B",
                });
                store.commit("setEnd", location);
                this.toast.success("End point selected!");
                this.calculateAndDisplayRoute();
                // console.log("End point selected:", location.toString());
            } else {
                // Remove old markers if both markers are already set
                this.resetMarkers();
                this.handleMapClick(location); // Set new start marker
            }
        },
        calculateAndDisplayRoute() {
            this.directionsService.route(
                {
                    origin: store.state.start,
                    destination: store.state.end,
                    travelMode: google.maps.TravelMode.DRIVING,
                },
                (response, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        this.directionsRenderer.setDirections(response);
                    } else {
                        // console.error(
                        //     "Directions request failed due to " + status
                        // );
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
            store.commit("resetPoints");
            this.directionsRenderer.setDirections({ routes: [] });
            this.toast.info(
                "Points have been reset! Click on the map to set the start point."
            );
            // console.log("Points have been reset!");
        },
    },
};
</script>

<style>
#map {
    height: 600px;
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
