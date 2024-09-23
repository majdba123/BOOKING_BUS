<template>
    <div>
        <div id="map"></div>
        <div id="mapMessages" class="map-messages">{{ message }}</div>
        <button @click="resetMarkers" class="reset-button">Reset Points</button>
        <div v-if="selectedMarker" class="marker-input">
            <input
                v-model="markerName"
                placeholder="Enter new name"
                @blur="clearSelection"
            />
            <button @click="updateMarkerName" class="update-button">
                Update Name
            </button>
            <button class="reset-button" @click="removeMarker">Remove</button>
        </div>
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
            breakMarker1: null,
            breakMarker2: null,
            addingBreaks: false,
            additionalBreaks: [],
            message: "",
            toast: useToast(),
            selectedMarker: null, // To store the currently selected marker
            markerName: "", // Name of the marker to edit
        };
    },
    mounted() {
        this.initMap();
        this.toast.info("Please select the 'FROM' point on the map.");
    },
    methods: {
        initMap() {
            this.map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 34.8021, lng: 38.9968 }, // Syria center
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
        showMessage(msg) {
            this.message = msg;
        },
        handleMapClick(location) {
            const latitude = location.lat();
            const longitude = location.lng();

            if (!this.startMarker) {
                // Set start point
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
                    "FROM point selected! Please select the 'TO' point."
                );
            } else if (!this.endMarker) {
                // Set end point
                this.endMarker = new google.maps.Marker({
                    position: { lat: latitude, lng: longitude },
                    map: this.map,
                    label: "B",
                });
                store.commit("setEndCoordinates", {
                    lat: latitude,
                    lng: longitude,
                });
                this.toast.success("TO point selected! Drawing route...");

                this.calculateAndDisplayRoute();
            } else if (this.addingBreaks && !this.breakMarker1) {
                this.addBreakMarker(1, latitude, longitude);
            } else if (this.addingBreaks && !this.breakMarker2) {
                this.addBreakMarker(2, latitude, longitude);
            }
        },
        calculateAndDisplayRoute() {
            const start = {
                lat: store.state.startLat,
                lng: store.state.startLng,
            };
            const end = { lat: store.state.endLat, lng: store.state.endLng };

            this.directionsService.route(
                {
                    origin: start,
                    destination: end,
                    travelMode: google.maps.TravelMode.DRIVING,
                },
                (response, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        this.directionsRenderer.setDirections(response);

                        // Calculate distance
                        const route = response.routes[0];
                        let totalDistance = 0;

                        route.legs.forEach((leg) => {
                            totalDistance += leg.distance.value; // Distance in meters
                        });

                        const distanceInKm = (totalDistance / 1000).toFixed(2); // Convert to km

                        this.showMessage(
                            `Route calculated! Distance: ${distanceInKm} km`
                        );

                        store.state.routeDistance = distanceInKm;

                        this.addingBreaks = true; // Ready for user to add breaks
                        this.toast.info("Please select the (Start) point .");
                    } else {
                        this.toast.error(
                            "Could not calculate route. Please try again."
                        );
                    }
                }
            );
        },
        addBreakMarker(breakNumber, lat, lng) {
            const breakMarker = new google.maps.Marker({
                position: { lat, lng },
                map: this.map,
                label: breakNumber === 1 ? "1" : "2",
                icon: {
                    url: "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
                },
            });

            if (breakNumber === 1) {
                this.breakMarker1 = breakMarker;
                store.commit("setBreakCoordinates1", { lat, lng });
                this.toast.success("Start point set! Now select End point.");
            } else if (breakNumber === 2) {
                this.breakMarker2 = breakMarker;
                store.commit("setBreakCoordinates2", { lat, lng });
                this.addingBreaks = false;
                this.toast.success("End point set!");

                const addMoreBreaks = confirm("Do you want to add breaks?");
                if (addMoreBreaks) {
                    this.enableAdditionalBreaks(); // Enable additional breaks
                } else {
                    this.toast.success("Click 'ADD' to Create Path");
                }
            }

            this.snapToRoute(breakMarker, lat, lng);

            google.maps.event.addListener(breakMarker, "click", () => {
                this.handleMarkerClick(breakMarker, breakNumber);
            });
        },
        enableAdditionalBreaks() {
            this.additionalBreaks = [];
            this.toast.info("Click on the map to add additional breaks.");

            this.map.addListener("click", (event) => {
                const lat = event.latLng.lat();
                const lng = event.latLng.lng();
                const breakName = prompt("Enter break name:");

                if (breakName) {
                    this.createAdditionalBreak(lat, lng, breakName);
                }
            });
        },
        createAdditionalBreak(lat, lng, breakName) {
            const additionalBreakMarker = new google.maps.Marker({
                position: { lat, lng },
                map: this.map,
                label: breakName,
                icon: {
                    url: "http://maps.google.com/mapfiles/ms/icons/orange-dot.png",
                },
            });

            this.additionalBreaks.push({
                name: breakName,
                lat: lat,
                lng: lng,
            });
            store.state.additionalBreaks.push({
                name: breakName,
                lat: lat,
                lng: lng,
            });

            this.toast.success(`Break "${breakName}" added successfully!`);
            this.snapToRoute(additionalBreakMarker, lat, lng);

            google.maps.event.addListener(
                additionalBreakMarker,
                "click",
                () => {
                    this.handleMarkerClick(additionalBreakMarker, breakName);
                }
            );
        },
        snapToRoute(marker, lat, lng) {
            const path =
                this.directionsRenderer.getDirections().routes[0].overview_path;

            let closestPoint = null;
            let minDistance = Number.MAX_VALUE;

            path.forEach((point) => {
                const distance =
                    google.maps.geometry.spherical.computeDistanceBetween(
                        new google.maps.LatLng(lat, lng),
                        point
                    );
                if (distance < minDistance) {
                    minDistance = distance;
                    closestPoint = point;
                }
            });

            if (closestPoint) {
                marker.setPosition(closestPoint);
            }
        },
        handleMarkerClick(marker, name) {
            this.selectedMarker = marker; // Set the selected marker
            this.markerName = name; // Populate input field with marker's name
        },
        updateMarkerName() {
            if (this.selectedMarker && this.markerName) {
                this.selectedMarker.setLabel(this.markerName);
                this.showMessage(`Marker renamed to "${this.markerName}".`);
                this.clearSelection();
            }
        },
        removeMarker() {
            if (this.selectedMarker) {
                this.selectedMarker.setMap(null); // Remove from the map
                this.showMessage(`Marker deleted.`);
                this.clearSelection();
            }
        },
        clearSelection() {
            this.selectedMarker = null; // Clear the selected marker
            this.markerName = ""; // Clear the input field
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
            if (this.breakMarker1) {
                this.breakMarker1.setMap(null);
                this.breakMarker1 = null;
            }
            if (this.breakMarker2) {
                this.breakMarker2.setMap(null);
                this.breakMarker2 = null;
            }
            store.commit("resetCoordinates");
            this.directionsRenderer.setDirections({ routes: [] });
            this.addingBreaks = false;
            this.showMessage(
                "Points have been reset! Click on the map to set the start point."
            );
        },
    },
};
</script>

<style>
#map {
    height: 550px;
    width: 100%;
}
.update-button {
    width: 100%;
    margin-top: 10px;
    padding: 10px 20px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.update-button:hover {
    background-color: #218838;
}

#mapMessages {
    position: absolute;
    bottom: 10px;
    left: 10px;
    background-color: rgba(255, 255, 255, 0.8);
    padding: 10px;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    font-size: 14px;
    max-width: 90%;
}

.marker-input {
    position: absolute;
    bottom: 60px;
    left: 10px;
    background-color: rgba(255, 255, 255, 0.8);
    padding: 10px;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.marker-input input {
    margin-right: 5px;
    padding: 5px;
}

.reset-button {
    width: 100%;
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
