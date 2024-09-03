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
    name: "MapPrivate",
    props: {
        fromlat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        fromlng: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        tolat: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
        tolng: {
            type: [Number, String],
            required: true,
            validator: (value) => !isNaN(parseFloat(value)),
        },
    },
    data() {
        return {
            map: null,
            directionsService: null,
            directionsRenderer: null,
        };
    },
    mounted() {
        this.loadGoogleMapsScript();
    },
    methods: {
        loadGoogleMapsScript() {
            const script = document.createElement("script");
            script.src = `https://maps.googleapis.com/maps/api/js?key=AIzaSyDd9RLeRSNjmt1AIx22VeWqwbxYh3myC44&libraries=places`;
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
            const toLat = parseFloat(this.tolat);
            const toLng = parseFloat(this.tolng);

            if (
                isNaN(fromLat) ||
                isNaN(fromLng) ||
                isNaN(toLat) ||
                isNaN(toLng)
            ) {
                console.error("Invalid latitude or longitude values");
                return;
            }

            if (typeof google !== "undefined") {
                this.map = new google.maps.Map(document.getElementById("map"), {
                    center: { lat: fromLat, lng: fromLng },
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
                    suppressMarkers: false, // لإظهار العلامات على المسار
                });

                const request = {
                    origin: { lat: fromLat, lng: fromLng },
                    destination: { lat: toLat, lng: toLng },
                    travelMode: google.maps.TravelMode.DRIVING, // يمكن تغيير نوع النقل هنا (قيادة، مشي، دراجة، ...)
                };

                this.directionsService.route(request, (result, status) => {
                    if (status === google.maps.DirectionsStatus.OK) {
                        this.directionsRenderer.setDirections(result);
                    } else {
                        console.error("Failed to display directions:", status);
                    }
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
