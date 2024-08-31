<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <div class="recent_orders">
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!filteredGovernment.length > 0"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Point</th>
                                    <th>Created At</th>
                                    <th>Profile</th>
                                    <th>All Reservation</th>
                                    <th>All Trip History</th>
                                    <th>Favorite of Company</th>
                                    <th>Private Order</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(user, index) in filteredGovernment"
                                    :key="index"
                                >
                                    <td>{{ user.id }}</td>
                                    <td>{{ user.name }}</td>
                                    <td>{{ user.email }}</td>
                                    <td>{{ user.point }}</td>
                                    <td>{{ user.created_at }}</td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-primary"
                                            @click="openBreackModal(user.id)"
                                        >
                                            View
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-success"
                                            @click="
                                                openReservationModal(user.id)
                                            "
                                        >
                                            View
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-warning"
                                            @click="openTripModal(user.id)"
                                        >
                                            View
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-info"
                                            @click="openFavModal(user.id)"
                                        >
                                            View
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-danger"
                                            @click="openOrderModal(user.id)"
                                        >
                                            View
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div v-if="showGovernmentBreackModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Profile</div>
            <div class="modal-body">
                <div v-if="loading1" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Profile.profile" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Phone</th>
                                    <th>Image</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>{{ Profile.profile?.phone }}</td>
                                    <td>
                                        <img
                                            :src="Profile.profile?.image"
                                            alt="Profile Image"
                                            class="profile-image"
                                        />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="closeGovernmentBreackModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>

    <div v-if="showReservationModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">All Reservation</div>
            <div class="modal-body">
                <div v-if="loading2" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Reservation.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Area Name</th>
                                    <th>Break Name</th>
                                    <th>Reservation Status</th>
                                    <th>Reservation Type</th>
                                    <th>Seat</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(driver, index) in Reservation"
                                    :key="index"
                                >
                                    <td>{{ driver.area_name }}</td>
                                    <td>{{ driver.break_name }}</td>
                                    <td>{{ driver.reservation_status }}</td>
                                    <td>{{ driver.reservation_type }}</td>
                                    <td>
                                        <button
                                            class="nav-btnd"
                                            @click="openSeat(index)"
                                        >
                                            View
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="closeReservationModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showTripModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">All Trip History</div>
            <div class="modal-body">
                <div v-if="loading3" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Trip.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>From</th>
                                    <th>To</th>
                                    <th>Price Trip</th>
                                    <th>From Time</th>
                                    <th>To Time</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Type</th>
                                    <th>Event</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(driver, index) in Trip"
                                    :key="index"
                                >
                                    <td>{{ driver.id }}</td>
                                    <td>{{ driver.from }}</td>
                                    <td>{{ driver.to }}</td>
                                    <td>{{ driver.price_trip }}</td>
                                    <td>{{ driver.from_time }}</td>
                                    <td>{{ driver.to_time }}</td>
                                    <td>{{ driver.date }}</td>
                                    <td>{{ driver.status }}</td>
                                    <td>{{ driver.type }}</td>
                                    <td>{{ driver.event }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="closeTripModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showFavModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">All Company Favorite</div>
            <div class="modal-body">
                <div v-if="loading4" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Fav.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID Company</th>
                                    <th>Name</th>
                                    <th>Image</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(driver, index) in Fav" :key="index">
                                    <td>{{ driver.company_id }}</td>

                                    <td>{{ driver.name_company }}</td>
                                    <td>
                                        <img
                                            :src="driver.image_company"
                                            alt="Profile Image"
                                            style="
                                                max-width: 100px;
                                                border-radius: 50%;
                                            "
                                        />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="closeFavModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showOrderModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Private Order</div>
            <div class="modal-body">
                <div v-if="loading5" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Order.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>from</th>
                                    <th>to</th>
                                    <th>date</th>
                                    <th>start_time</th>
                                    <th>status</th>
                                    <th>Approved Company</th>

                                    <th>price</th>
                                    <th>status</th>
                                    <th>Trip In Map</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(driver, index) in Order"
                                    :key="index"
                                >
                                    <td>{{ driver.Private_trip_id }}</td>

                                    <td>{{ driver.from }}</td>
                                    <td>{{ driver.to }}</td>
                                    <td>{{ driver.date }}</td>
                                    <td>{{ driver.start_time }}</td>
                                    <td>{{ driver.status }}</td>
                                    <td>
                                        {{
                                            driver.order_private_trip[0]
                                                ?.company_name
                                        }}
                                    </td>

                                    <td>
                                        {{
                                            driver.order_private_trip[0]?.price
                                        }}
                                    </td>

                                    <td>
                                        {{
                                            driver.order_private_trip[0]
                                                ?.payment_status
                                        }}
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd"
                                            @click="openMapModal(driver.id)"
                                        >
                                            View
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="closeOrderModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showMapModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Location on Map</div>
            <div class="modal-body">
                <MapPrivate
                    :fromlat="mapfromLat"
                    :fromlng="mapfromLng"
                    :tolat="maptoLat"
                    :tolng="maptoLng"
                />
            </div>
            <div class="modal-footer">
                <button @click="closeMapModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showSeatModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">All Seat</div>
            <div class="modal-body">
                <div v-if="loading6" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Seat.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(driver, index) in Seat"
                                    :key="index"
                                >
                                    <td>{{ driver.seat_id }}</td>
                                    <td>{{ driver.status }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button @click="closeSeatModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
</template>

<script>
import MapPrivate from "./MapPrivate.vue";
import axios from "axios";
import store from "@/store";
import { useToast } from "vue-toastification";

export default {
    name: "AddDriver",
    data() {
        return {
            loading: true,
            loading1: true,
            loading2: true,
            loading3: true,
            loading4: true,
            loading5: true,
            loading6: true,

            showMapModal: false,
            Order: [],
            Fav: [],
            Trip: [],
            showSeatModal: false,
            Seat: [],
            showReservationModal: false,
            showTripModal: false,
            showFavModal: false,
            showOrderModal: false,
            mapfromLat: "",
            maptoLat: "",
            mapfromLng: "",
            maptoLng: "",
            Users: [],
            Profile: [],
            Reservation: [],
            currentCompanyId: "",
            showGovernmentBreackModal: false,
            toast: useToast(),
            isDarkMode: false, // إدارة حالة الوضع الداكن
        };
    },
    mounted() {
        this.AllUsers();

        this.isDarkMode = localStorage.getItem("theme") === "dark";
        if (this.isDarkMode) {
            document.body.classList.add("dark-theme-variables");
        }
    },
    methods: {
        openMapModal(id) {
            const government = this.Order.find((breack) => breack.id === id);
            if (government) {
                this.mapfromLat = government.from_lat;
                this.mapfromLng = government.from_long;
                this.maptoLat = government.to_lat;
                this.maptoLng = government.to_long;
                this.showMapModal = true;
                console.log(this.mapfromLat, this.mapfromLng);
            }
        },
        openBreackModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchProfile(this.currentCompanyId);
            this.showGovernmentBreackModal = true;
        },
        openReservationModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchReservation(this.currentCompanyId);
            this.showReservationModal = true;
        },
        openTripModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchTrip(this.currentCompanyId);
            this.showTripModal = true;
        },
        openFavModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchFav(this.currentCompanyId);
            this.showFavModal = true;
        },
        openOrderModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchOrder(this.currentCompanyId);
            this.showOrderModal = true;
        },
        openSeat(x) {
            // Set the current company ID
            this.fetchReservationSeat(x, this.currentCompanyId);
            this.showSeatModal = true;
        },
        closeMapModal() {
            this.showMapModal = false;
        },

        closeSeatModal() {
            this.showSeatModal = false;
        },
        closeReservationModal() {
            this.showReservationModal = false;
        },
        closeTripModal() {
            this.showTripModal = false;
        },
        closeFavModal() {
            this.showFavModal = false;
        },
        closeOrderModal() {
            this.showOrderModal = false;
        },
        closeGovernmentBreackModal() {
            this.showGovernmentBreackModal = false;
        },

        AllUsers() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/all_user",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Users = response.data;
                    store.state.User = response.data;
                    this.loading = false;
                    console.log(response.data);
                })
                .catch((error) => {
                    this.toast.error("Error getting drivers.");
                    console.error(error);
                });
            this.loading = true;
        },

        fetchProfile(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/admin/show_user_details/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Profile = response.data;
                    this.loading1 = false;

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching Profile");
                    console.error(error);
                });
            this.loading1 = true;
        },
        fetchReservationSeat(x, status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/user_reservation_info/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Reservation = response.data;

                    this.Seat = response.data[x].seat;
                    this.loading6 = false;
                    console.log(this.Seat);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading6 = true;
        },
        fetchReservation(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/user_reservation_info/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Reservation = response.data;
                    this.loading2 = false;

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading2 = true;
        },
        fetchOrder(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/private_order_of_user/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Order = response.data;
                    this.loading5 = false;

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading5 = true;
        },
        fetchFav(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/favourite_company_of_user/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Fav = response.data;
                    this.loading4 = false;

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading4 = true;
        },
        fetchTrip(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_trip_history_of_user/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Trip = response.data;
                    this.loading3 = false;

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading3 = true;
        },

        toggleTheme() {
            this.isDarkMode = !this.isDarkMode;
            document.body.classList.toggle(
                "dark-theme-variables",
                this.isDarkMode
            );
            localStorage.setItem("theme", this.isDarkMode ? "dark" : "light");
        },
    },
    computed: {
        filteredGovernment() {
            const users = this.$store.state.User;

            if (!Array.isArray(users)) {
                return [];
            }
            return store.state.User.filter((driver) => {
                return (
                    driver.name
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.email
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase())
                );
            });
        },
    },
    components: { MapPrivate },
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
    --padding-1: 1.2rem;

    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
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
    background: #f6f6f9;
    overflow-y: auto;
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
}

h2 {
    font-size: 1.4rem;
}
.btn-primary {
    background: linear-gradient(90deg, #7380ec 0%, #4b6cb7 100%) !important;
}

.btn-success {
    background: linear-gradient(90deg, #41f1b6 0%, #28a745 100%) !important;
}

.btn-warning {
    background: linear-gradient(90deg, #ffc107 0%, #e0a800 100%) !important;
}

.btn-info {
    background: linear-gradient(90deg, #17a2b8 0%, #117a8b 100%) !important;
}

.btn-danger {
    background: linear-gradient(90deg, #ff7782 0%, #d9534f 100%) !important;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid #fff;
    color: #677483;
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid #363949;
    color: #677483;
}

table tbody tr:last-child td {
    border: none;
}

table thead tr th {
    padding: 10px !important;
    font-size: 0.9rem !important;
}

table tbody tr {
    height: 3rem !important;
    border-bottom: 1px solid #fff !important;
    color: #677483 !important;
}

table tbody td {
    height: 3rem !important;
    border-bottom: 1px solid #363949 !important;
    color: #677483 !important;
}

table tbody tr:last-child td {
    border: none !important;
}

.recent_orders {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.recent_orders table {
    background-color: #fff;
    width: 100%;
    border-radius: 10px;
    padding: 1rem;
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    font-size: 0.85rem;
    border-collapse: collapse;
}

.recent_orders thead {
    background-color: var(--clr-primary);
    color: #fff;
}

.recent_orders th,
.recent_orders td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}
/* أنيميشن الـ Spinner */
.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* تجعل الـ spinner يأخذ كامل الشاشة */
}

.spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-left-color: #007bff;
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

.recent_orders tbody tr:hover {
    background-color: #f1f1f1;
}

.recent_orders td {
    text-align: center;
}

.nav-btnd {
    padding: 8px 16px;
    border: none;
    border-radius: var(--border-radius-2);
    background: #4caf50;
    color: #fff;
    cursor: pointer;
    font-size: 0.85rem;
    transition: background-color 0.3s;
}

.nav-btnd.btn-primary {
    background: #7380ec;
}

.nav-btnd.btn-success {
    background: #4caf50;
}

.nav-btnd.btn-warning {
    background: #ff9800;
}

.nav-btnd.btn-info {
    background: #17a2b8;
}

.nav-btnd.btn-danger {
    background: #f44336;
}

.nav-btnd:hover {
    opacity: 0.9;
}

/* Responsive Design */
@media (max-width: 1200px) {
    .recent_orders table {
        font-size: 0.75rem;
    }
}

@media (max-width: 768px) {
    .recent_orders table,
    .recent_orders thead,
    .recent_orders tbody,
    .recent_orders th,
    .recent_orders td,
    .recent_orders tr {
        display: block;
    }

    .recent_orders thead tr {
        position: absolute;
        top: -9999px;
        left: -9999px;
    }

    .recent_orders tr {
        border: 1px solid #ddd;
        margin-bottom: 10px;
        display: flex;
        flex-direction: column;
    }

    .recent_orders td {
        border: none;
        position: relative;
        padding-left: 50%;
        text-align: left;
    }

    .recent_orders td::before {
        content: attr(data-label);
        position: absolute;
        left: 0;
        width: 45%;
        padding-left: 10px;
        white-space: nowrap;
        font-weight: bold;
        color: var(--clr-primary);
    }
}
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    font-size: 1.2rem;
    color: #677483;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background-color: #f6f6f9;
}
/* Select styling */
select {
    padding: 8px;
    border: 1px solid #7380ec;
    border-radius: 4px;
    background-color: #fff;
    color: #363949;
}

select:focus {
    border-color: #007bff;
}

/* Button styling */
.edit-btns {
    color: #f1f1f1;
    background-color: #4caf50;
    border-radius: 9px;
    padding: 10px;
    margin: 5px;
    transition: background-color 0.3s;
}
.edit-btns:hover {
    background-color: #3a8d3c;
}
.edit-btn.material-icons,
.delete-btn.material-icons,
.status-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 8px;
    border-radius: 3px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 20px;
    width: 20px;
    cursor: pointer;
}

.edit-btn {
    color: #4caf50;
    background-color: #f1f1f1;
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}
.edit-btn:hover {
    color: #fff;
    background-color: #4caf50;
}

.delete-btn {
    color: #f44336;
    background-color: #f1f1f1;
    border-radius: 9px;
    padding: 3px;
}

.delete-btn:hover {
    color: #fff;
    background-color: #f44336;
}
/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: #fff;
    border-radius: 10px;
    width: 100%;
}

@keyframes gradientAnimation {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.nav-btnd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s ease;
}

/* Form and Map styling */
.form-map-container {
    display: flex;
    justify-content: space-between;
    width: 100%;
    margin-top: 20px;
    height: 350px;
}
.form-containerd {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100%;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    max-width: 400px;
    width: 100%;
    text-align: center;
}
h2 {
    margin-bottom: 20px;
    font-size: 1.5rem;
    color: #333;
}
.form-groupd {
    width: 100%;
    margin-bottom: 15px;
}

label {
    display: block;
    margin-bottom: 5px;
    text-align: left;
    font-weight: bold;
}

input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
}

input:focus {
    border-color: #007bff;
}

.submit-btnnd {
    margin-top: auto;
    display: flex;
    justify-content: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s;
}

.submit-btnd:hover {
    background-color: #0056b3;
}

.map-container {
    flex: 1;
    margin-left: 10px;
    min-width: 400px;
    border-radius: 20px;
}
.map-containers {
    flex: 1;
    margin-top: 20px;
    min-width: 400px;
    border-radius: 20px;
}

@media screen and (max-width: 1200px) {
    .form-map-container {
        flex-direction: column;
        align-items: center;
    }

    .form-containerd,
    .map-container {
        width: 100%;
        margin-top: 20px;
    }
}

/* Edit Modal Styling */
/* Modal Styles */
.modal {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
}
.modal-content {
    background: #fff;
    padding: 20px;
    border-radius: var(--border-radius-2);
    max-width: 90%;
    width: 90%;
    height: auto;
    max-height: 80%;
    box-shadow: var(--box-shadow);
    overflow: auto;
}

.modal-header,
.modal-body div div,
.modal-footer {
    margin-bottom: 15px;
}

.modal-header {
    font-size: 1.5rem;
    font-weight: bold;
    text-align: center;
    padding-bottom: 10px;
    border-bottom: 2px solid var(--clr-primary);
}

.modal-body div div {
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal-body div div table {
    width: 100%;
    border-collapse: collapse;
}

.modal-body div div th,
.modal-body div div td {
    padding: 12px;
    text-align: left;
}

.modal-body div div th {
    background-color: var(--clr-primary);
    color: #fff;
}

.modal-body div div td {
    border-bottom: 1px solid #ddd;
}

.profile-image {
    max-width: 100px;
    border-radius: 50%;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
}

.close-modal {
    padding: 10px 20px;
    background-color: var(--clr-danger);
    color: #fff;
    border: none;
    border-radius: var(--border-radius-2);
    cursor: pointer;
    transition: background-color 0.3s;
}

.close-modal:hover {
    background-color: #c9302c;
}

/* Responsive Design */
@media (max-width: 768px) {
    .modal-content {
        width: 95%;
        height: auto;
    }

    .modal-body {
        flex-direction: column;
    }

    .profile-image {
        max-width: 80px;
    }
}

.update-btn {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-right: 10px;
}
.update-btn:hover {
    background-color: #489248;
}
</style>
