<template>
    <div id="app">
        <div id="map-container">
            <input id="pac-input" type="text" placeholder="Search Box" />
            <div id="map"></div>
        </div>
    </div>
</template>

<script>
/* global google */
import store from "@/store";
import { useToast } from "vue-toastification";
import { loadGoogleMaps } from "@/utils/googleMapsLoader";

export default {
    name: "UpdateMapGovernment",
    data() {
        return {
            map: null,
            infoWindow: null,
            toast: null,
        };
    },
    async mounted() {
        this.toast = useToast();

        try {
            await loadGoogleMaps();
            this.initAutocomplete();
            this.toast.info("Please search for a Government.");
        } catch (error) {
            console.error("Unable to initialize Google Maps:", error);
            this.toast.error("Unable to load Google Maps.");
        }
    },
    methods: {
        initAutocomplete() {
            if (typeof google === "undefined") {
                return;
            }

            this.map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 34.8021, lng: 38.9968 },
                zoom: 7,
                mapTypeId: "roadmap",
            });

            const input = document.getElementById("pac-input");
            const searchBox = new google.maps.places.SearchBox(input);
            this.infoWindow = new google.maps.InfoWindow();

            this.map.addListener("bounds_changed", () => {
                searchBox.setBounds(this.map.getBounds());
            });

            let markers = [];

            searchBox.addListener("places_changed", () => {
                const places = searchBox.getPlaces();

                if (places.length === 0) {
                    return;
                }

                markers.forEach((marker) => marker.setMap(null));
                markers = [];

                const bounds = new google.maps.LatLngBounds();

                places.forEach((place) => {
                    if (!place.geometry || !place.geometry.location) {
                        return;
                    }

                    const marker = new google.maps.Marker({
                        map: this.map,
                        title: place.name,
                        position: place.geometry.location,
                        icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
                    });

                    marker.addListener("click", () => {
                        const contentString = `
                            <div>
                                <strong>${place.name}</strong>
                                <br>
                                تم اختيار المنطقة
                            </div>
                        `;
                        this.infoWindow.setContent(contentString);
                        this.infoWindow.open(this.map, marker);

                        store.state.placeName = place.name;
                        store.state.lat = place.geometry.location.lat();
                        store.state.lng = place.geometry.location.lng();
                    });

                    markers.push(marker);

                    if (place.geometry.viewport) {
                        bounds.union(place.geometry.viewport);
                    } else {
                        bounds.extend(place.geometry.location);
                    }
                });

                this.map.fitBounds(bounds);
                this.toast.success("Please select the region(Click).");
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

#pac-input {
    padding: 10px;
    font-size: 16px;
    width: calc(100% - 20px);
    box-sizing: border-box;
    position: absolute;
    top: 10px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1000;
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 3px;
}
</style>
