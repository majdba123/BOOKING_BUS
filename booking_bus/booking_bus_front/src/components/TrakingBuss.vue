<template>
    <!-- Header with buttons -->
    <div v-if="showForm" class="form-map-container">
        <form @submit.prevent="handleSubmit" class="form-containerd">
            <div class="select-group">
                <div class="select-container">
                    <h3>Select Trip</h3>

                    <select v-model="trip_id" @change="AllPaths(trip_id)">
                        <option
                            v-for="(busItem, i) in trips.data"
                            :key="i"
                            :value="busItem.id"
                        >
                            {{ busItem.path.from }} ->
                            {{ busItem.path.to }} Price:
                            {{ busItem.price }}
                        </option>
                    </select>
                </div>

                <div class="select-container">
                    <h3>Select Bus Trip</h3>
                    <select v-model="bus_id" @change="initializePusher()">
                        <option
                            v-for="(busItem, i) in Paths"
                            :key="i"
                            :value="busItem.bus_id"
                        >
                            {{ busItem.bus_id }}
                        </option>
                    </select>
                </div>
            </div>
        </form>
        <div class="map-container">
            <TrackingMap
                :fromlat="this.fromlat"
                :fromlong="this.fromlang"
                :tolat="this.tolat"
                :tolong="this.tolang"
                :latbus="this.lat"
                :longbus="this.lang"
            />
        </div>
    </div>
</template>
<script>
import Pusher from "pusher-js";
import axios from "axios";
import store from "@/store";
import TrackingMap from "./TrackingMap.vue";
import { useToast } from "vue-toastification";

export default {
    name: "TrackingBuss",
    components: { TrackingMap },
    data() {
        return {
            fromlat: "",
            fromlang: "",
            tolat: "",
            tolang: "",
            bus_id: "",
            trip_id: "",
            trips: [],
            lat: null,
            lang: null,
            frommapLat: null,
            frommapLog: null,
            tomapLat: null,
            tomapLog: null,
            showMapModal: false,
            loading: true,
            id: "",
            showForm: true,
            Paths: [],
            StartPath: "",
            EndPath: "",
            showEditModal: false,
            editedPath: { from: "", to: "" },
            editingIndex: null,
            toast: useToast(),
            showDeleteConfirmModal: false,
            pathToDelete: {},
        };
    },
    mounted() {
        this.AllUsers();
        this.initializePusher();
        this.AllPaths();
    },
    methods: {
        complate() {
            // console.log(this.bus_id);
        },
        initializePusher() {
            Pusher.logToConsole = true;
            const pusher = new Pusher("7342c00647f26084d14f", {
                cluster: "ap2",
                authEndpoint: "/pusher/auth",
            });

            const channel = pusher.subscribe(
                "trip-geolocation-private-channel-" + this.bus_id
            );
            // console.log("Pusher Channel:", channel);

            channel.bind("tripgeolocationEvent", (data) => {
                const notification = data;
                this.lat = notification.lat;
                this.lang = notification.lang;

                // console.log("Lat/Lang:", this.lang, this.lat);
                this.$store.commit(
                    "ADD_TRAKING",
                    notification.lat,
                    notification.lang
                );
                this.lat = notification.lat;
                // console.log("Lat/Lang:", this.lang, this.lat);
            });
        },
        AllUsers() {
            const access_token = window.localStorage.getItem("access_token");
            this.loading = true;
            return axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_trips",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.trips = response.data;
                    // console.log("User ID:", this.trips);
                })
                .catch(() => {
                    this.toast.error("Error getting user info.");
                });
        },
        closeMapModal() {
            this.showMapModal = false;
        },
        openMapModal(id) {
            this.id = id;
            const government = this.Paths.find((breack) => breack.id === id);
            // console.log(this.governments);
            if (government) {
                this.frommapLat = government.from_latitude;
                this.frommapLog = government.from_longitude;
                this.tomapLat = government.to_latitude;
                this.tomapLog = government.to_longitude;
                this.showMapModal = true;
                // console.log(
                //     this.tomapLog,
                //     this.frommapLat,
                //     this.frommapLog,
                //     this.tomapLat
                // );
            }
        },
        handleSubmit() {
            // console.log("Form Submitted", this.StartPath, this.EndPath);
        },

        AllPaths(ID) {
            for (let index = 0; index < this.trips.length; index++) {
                if (this.trips[index].id == ID) {
                    this.fromlat = this.trips[index].path.from_latitude;
                    this.fromlang = this.trips[index].path.from_longitude;
                    this.tolat = this.trips[index].path.to_latitude;
                    this.tolang = this.trips[index].path.to_longitude;
                    // console.log(
                    //     ID,
                    //     this.fromlat,
                    //     this.fromlang,
                    //     this.tolang,
                    //     this.tolat
                    // );
                }
            }
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url:
                    "http://127.0.0.1:8000/api/company/get_bus_trip/" +
                    this.trip_id,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Paths = response.data;
                    this.loading = false;
                    console.log(response.data);
                })
                .catch(() => {});
            this.loading = true;
        },
        openDeleteConfirmModal(path) {
            this.pathToDelete = path;
            this.showDeleteConfirmModal = true;
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
        },
        deleteConfirmedPath() {
            const id = this.pathToDelete.id;
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/path_delete/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.Paths = this.Paths.filter(
                        (pathItem) => pathItem.id !== id
                    );
                    this.toast.success("Path Deleted Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.AllPaths();
                })
                .catch(() => {
                    this.toast.error("Error Deleting Path", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                })
                .finally(() => {
                    this.closeDeleteConfirmModal();
                });
        },
        openEditModal(path, index) {
            this.editedPath = { ...path };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        closeEditModal() {
            this.showEditModal = false;
        },
        updatePath() {
            const id = this.editedPath.id;
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/path_update/${id}`,
                data: {
                    from: this.editedPath.from,
                    to: this.editedPath.to,
                    lat_from: store.state.startLat,
                    long_from: store.state.startLng,
                    lat_to: store.state.endLat,
                    long_to: store.state.endLng,
                    Distance: store.state.distance,
                },
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.Paths[this.editingIndex] = { ...this.editedPath };
                    this.toast.success("Path Updated Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.AllPaths();
                })
                .catch(() => {
                    this.toast.error("Error Updating Path", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                })
                .finally(() => {
                    this.closeEditModal();
                });
        },
    },
    computed: {
        filteredPaths() {
            return this.Paths;
        },
    },
};
</script>

<style scoped>
:root {
    --clr-primary: #7380ec;
    --clr-danger: #ff7782;
    --clr-success: #41f1b6;
    --clr-white: #fff;
    --clr-dark: #363949;
    --clr-light: rgba(132, 139, 200, 0.18);
    --clr-primary-variant: #111e88;
    --clr-dark-variant: #677483;
    --clr-color-background: #f6f6f9;
    --border-radius-1: 0.4rem;
    --border-radius-2: 0.8rem;
    --border-radius-3: 0.9rem;
    --padding-1: 1.2rem;
    --box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

/* Dark theme variables */
.dark-theme-variables {
    --clr-primary: #bb86fc;
    --clr-danger: #cf6679;
    --clr-success: #03dac6;
    --clr-white: #121212;
    --clr-info-dark: #bb86fc;
    --clr-info-light: #292929;
    --clr-dark: #f6f6f9;
    --clr-warning: #ffbb55;
    --clr-light: rgba(255, 255, 255, 0.2);
    --clr-primary-variant: #3700b3;
    --clr-dark-variant: #1f1f1f;
    --clr-color-background: #121212;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
    border: 0;
    list-style: none;
    appearance: none;
}

body {
    font-family: "Poppins", sans-serif;
    width: 100%;
    height: 100%;
    font-size: 0.88rem;
    background: var(--clr-color-background);
    overflow-y: auto;
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
    color: var(--clr-dark);
}

h3 {
    display: flex;
    justify-content: center;
    color: var(--clr-dark);
    align-items: center;
    margin-bottom: 5px;
}

.recent_orders {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders table {
    width: 100%;
    border-radius: var(--border-radius-1);
    padding: var(--padding-1);
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
    background-color: var(--clr-white);
}

.recent_orders table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}

table tbody tr:last-child td {
    border: none;
}

.recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
    font-size: 0.85rem;
    color: var(--clr-primary);
}

/* No data message */
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    font-size: 1.2rem;
    color: var(--clr-dark);
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background: var(--clr-white);
}

/* Select styling */
select {
    padding: 8px;
    border: 1px solid var(--clr-primary);
    border-radius: 4px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    margin-bottom: 10px;
    width: 100%;
}

select:focus {
    border-color: var(--clr-primary-variant);
}

/* Button styling */
.edit-btns {
    color: var(--clr-white);
    background-color: var(--clr-success);
    border-radius: var(--border-radius-2);
    padding: 10px;
    margin: 5px;
    transition: background-color 0.3s;
}

.edit-btns:hover {
    background-color: var(--clr-dark-variant);
}

/* Spinner */
.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh;
}

.spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}

/* Button styles with icons */
.submit-btnnd {
    display: flex;
    justify-content: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s, transform 0.2s;
}

.submit-btnd:hover {
    background-color: var(--clr-primary-variant);
    transform: translateY(-3px);
}
/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    background-color: var(--clr-white);
    border-radius: var(--border-radius-3);
    width: 100%;
    max-width: 800px;
    margin-top: 15px;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: var(--border-radius-2);
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 15px;
    transition: transform 0.2s, box-shadow 0.2s;
}

.nav-btnd:hover {
    transform: scale(1.05);
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.2);
}

.nav-btnd:focus {
    outline: none;
}

#header {
    width: 100%;
    padding: 0;
    background: var(--clr-primary);
    height: 60px;
    color: var(--clr-white);
    display: flex;
    align-items: center;
    justify-content: center;
}

#header h1 {
    font-size: 1.6rem;
}

/* Form and map container styling */
.form-map-container {
    display: flex;
    flex-direction: column;
    height: 100vh;
}

.form-containerd {
    padding: 20px;
    background-color: var(--clr-white);
    box-shadow: var(--box-shadow);
    border-radius: var(--border-radius-2);
    margin-bottom: 20px;
}

.select-group {
    display: flex;
    gap: 20px;
}

.select-container {
    flex: 1;
}

.map-container {
    flex: 1;
    height: 100%;
    overflow: hidden;
}

/* Mobile responsiveness */
@media (max-width: 768px) {
    .form-containerd {
        padding: 15px;
    }

    .map-container {
        height: 60vh;
    }

    .select-group {
        flex-direction: column;
        gap: 10px;
    }
}
</style>
