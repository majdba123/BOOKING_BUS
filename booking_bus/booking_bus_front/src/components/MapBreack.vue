<template>
    <div id="app">
        <div id="map-container">
            <div id="map"></div>
        </div>
    </div>
</template>

<script>
/* global google */
import { useToast } from "vue-toastification";

export default {
    name: "MapBreack",
    props: {
        lat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        lng: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
    },
    data() {
        return {
            map: null,
            initialMarker: null, // علامة ثابتة باللون الأحمر
            newMarker: null, // علامة متغيرة باللون الأزرق
            toast: useToast(), // استخدام useToast
        };
    },
    mounted() {
        this.loadGoogleMapsScript();
    },
    watch: {
        lat(newLat) {
            this.updateMap(parseFloat(newLat), parseFloat(this.lng));
        },
        lng(newLng) {
            this.updateMap(parseFloat(this.lat), parseFloat(newLng));
        },
    },
    methods: {
        updateMap(lat, lng) {
            if (this.map && this.initialMarker) {
                const position = { lat, lng };
                this.map.setCenter(position);
                this.initialMarker.setPosition(position);
                this.toast.info(
                    `Map updated to new position: (${lat}, ${lng})`
                );
            } else {
                this.initMap();
            }
        },
        loadGoogleMapsScript() {
            const script = document.createElement("script");
            script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyDhQD0CiLwIDWv0AR7noQSjX1w0SU6pHGo&libraries=places`;
            script.async = true;
            script.defer = true;
            document.head.appendChild(script);

            script.onload = () => {
                this.initMap();
                this.toast.success("Google Maps loaded successfully!");
            };

            script.onerror = () => {
                console.error("Failed to load Google Maps script");
                this.toast.error(
                    "Failed to load Google Maps script. Retrying..."
                );
                setTimeout(this.loadGoogleMapsScript, 3000);
            };
        },
        initMap() {
            const lat = parseFloat(this.lat);
            const lng = parseFloat(this.lng);

            if (isNaN(lat) || isNaN(lng)) {
                console.error("Invalid latitude or longitude values");
                this.toast.error("Invalid latitude or longitude values.");
                return;
            }

            if (typeof google !== "undefined") {
                this.map = new google.maps.Map(document.getElementById("map"), {
                    center: { lat: lat, lng: lng },
                    zoom: 15,
                    mapTypeId: "roadmap",
                    disableDefaultUI: false,
                    draggable: true,
                    scrollwheel: true,
                    disableDoubleClickZoom: false,
                });

                this.initialMarker = new google.maps.Marker({
                    position: { lat: lat, lng: lng },
                    map: this.map,
                    draggable: false,
                    icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png", // العلامة باللون الأحمر
                });

                this.toast.info(
                    "Please click on the map to select the break location."
                ); // إشعار المستخدم بتحديد المكان

                this.map.addListener("click", (event) => {
                    const clickedLat = event.latLng.lat();
                    const clickedLng = event.latLng.lng();
                    this.addNewMarker(clickedLat, clickedLng);
                    this.toast.info(
                        `New point selected at: (${clickedLat}, ${clickedLng})`
                    );
                });

                this.toast.success("Map initialized successfully!");
            } else {
                console.error("Google Maps not loaded yet");
                this.toast.error("Google Maps not loaded yet. Retrying...");
                setTimeout(this.initMap, 3000);
            }
        },
        addNewMarker(lat, lng) {
            if (this.newMarker) {
                this.newMarker.setMap(null);
            }

            this.newMarker = new google.maps.Marker({
                position: { lat: lat, lng: lng },
                map: this.map,
                draggable: true,
                icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png", // العلامة باللون الأزرق
            });

            this.updateLocation(lat, lng);

            this.newMarker.addListener("dragend", () => {
                const position = this.newMarker.getPosition();
                const newLat = position.lat();
                const newLng = position.lng();
                this.updateLocation(newLat, newLng);
                this.toast.info(
                    `Marker dragged to new location: (${newLat}, ${newLng})`
                );
            });

            this.toast.success(`New marker added at: (${lat}, ${lng})`);
        },
        updateLocation(lat, lng) {
            this.$store.state.breacklat = lat;
            this.$store.state.breacklong = lng;
            this.toast.info(`Location updated in store: (${lat}, ${lng})`);
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
