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
            marker: null,
        };
    },
    mounted() {
        this.loadGoogleMapsScript();
    },
    methods: {
        loadGoogleMapsScript() {
            const script = document.createElement("script");
            script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyDhQD0CiLwIDWv0AR7noQSjX1w0SU6pHGo&libraries=places`;
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
            const lat = parseFloat(this.lat);
            const lng = parseFloat(this.lng);

            if (isNaN(lat) || isNaN(lng)) {
                console.error("Invalid latitude or longitude values");
                return;
            }

            if (typeof google !== "undefined") {
                this.map = new google.maps.Map(document.getElementById("map"), {
                    center: { lat: lat, lng: lng },
                    zoom: 15,
                    mapTypeId: "roadmap",
                    disableDefaultUI: true,
                    draggable: false,
                    scrollwheel: false,
                    disableDoubleClickZoom: true,
                });

                this.marker = new google.maps.Marker({
                    position: { lat: lat, lng: lng },
                    map: this.map,
                    icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
                });

                this.marker.addListener("click", () => {
                    const infoWindow = new google.maps.InfoWindow({
                        content: `<div><strong>Selected Location</strong></div>`,
                    });
                    infoWindow.open(this.map, this.marker);
                });
            } else {
                console.error("Google Maps not loaded yet");
                setTimeout(this.initMap, 3000);
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
}
</style>
