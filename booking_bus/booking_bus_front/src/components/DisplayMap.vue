<template>
    <div id="app">
        <div id="map-container">
            <div id="map"></div>
        </div>
    </div>
</template>

<script>
/* global google */
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
    mounted() {
        this.loadGoogleMapsScript();
    },
    methods: {
        loadGoogleMapsScript() {
            // Remove any existing Google Maps script to avoid loading multiple times
            const existingScript = document.querySelector(
                'script[src*="maps.googleapis.com"]'
            );
            if (existingScript) {
                existingScript.remove();
            }

            const script = document.createElement("script");
            script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44&libraries=places,geometry`;
            script.async = true;
            script.defer = true;
            document.head.appendChild(script);

            script.onload = () => {
                console.log("Google Maps API loaded successfully.");
                this.initMap();
            };

            script.onerror = () => {
                console.error("Failed to load Google Maps API script.");
            };
        },
        initMap() {
            if (typeof google === "undefined") {
                console.error("Google Maps API is not available.");
                return;
            }

            // Parse and validate all latitude and longitude values
            const fromLat = parseFloat(this.fromlat);
            const fromLng = parseFloat(this.fromlong);
            const toLat = parseFloat(this.tolat);
            const toLng = parseFloat(this.tolong);
            const lat = this.lat ? parseFloat(this.lat) : null;
            const lng = this.lng ? parseFloat(this.lng) : null;

            // Log the values to debug
            console.log("Parsed values:", {
                fromLat,
                fromLng,
                toLat,
                toLng,
                lat,
                lng,
            });

            // Validate all latitude and longitude values
            if (
                isNaN(fromLat) ||
                isNaN(fromLng) ||
                isNaN(toLat) ||
                isNaN(toLng) ||
                (lat !== null && isNaN(lng))
            ) {
                console.error("Invalid latitude or longitude values");
                return;
            }

            console.log("Initializing map with center:", {
                lat: (fromLat + toLat) / 2,
                lng: (fromLng + toLng) / 2,
            });

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

            if (fromLat && fromLng && toLat && toLng) {
                this.calculateAndDisplayRoute(fromLat, fromLng, toLat, toLng);
            }

            if (lat !== null && lng !== null) {
                console.log("Adding marker at:", { lat, lng });

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
                console.error(
                    "DirectionsService or DirectionsRenderer is not available."
                );
                return;
            }

            console.log("Calculating route from:", {
                fromLat,
                fromLng,
                toLat,
                toLng,
            });

            const request = {
                origin: { lat: fromLat, lng: fromLng },
                destination: { lat: toLat, lng: toLng },
                travelMode: google.maps.TravelMode.DRIVING,
            };

            this.directionsService.route(request, (result, status) => {
                if (status === google.maps.DirectionsStatus.OK) {
                    console.log("Route calculated successfully.");
                    this.directionsRenderer.setDirections(result);
                } else {
                    console.error("Directions request failed due to " + status);
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
