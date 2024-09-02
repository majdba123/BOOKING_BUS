<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="toggleTripRatings">
                Trip Ratings
            </button>
            <button class="nav-btnd" @click="toggleDriverRatings">
                Driver Ratings
            </button>
            <button class="nav-btnd" @click="toggleAllTrips">All Trips</button>
            <button class="nav-btnd" @click="toggleAllDrivers">
                All Drivers
            </button>
        </header>

        <!-- Start all trips table -->
        <div v-if="showAllTrips" class="recent_orders">
            <h1>All Trips</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Trips.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Trip ID</th>
                                    <th>Status</th>
                                    <th>From</th>
                                    <th>To</th>
                                    <th>Price</th>
                                    <th>View Ratings</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(trip, index) in Trips" :key="index">
                                    <td>{{ index }}</td>
                                    <td>{{ trip.status }}</td>
                                    <td>{{ trip.path?.from }}</td>
                                    <td>{{ trip.path?.to }}</td>
                                    <td>{{ trip.price }}</td>
                                    <td>
                                        <button
                                            class="status-btn view-ratings-btn"
                                            @click="
                                                openTripRatingsModal(trip.id)
                                            "
                                        >
                                            View Ratings
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Start all drivers table -->
        <div v-if="showAllDrivers" class="recent_orders">
            <h1>All Drivers</h1>
            <div class="table-container">
                <div v-if="loading1" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Drivers.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Driver ID</th>
                                    <th>Name</th>
                                    <th>View Ratings</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(driver, index) in Drivers"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ driver.name }}</td>
                                    <td>
                                        <button
                                            class="status-btn view-ratings-btn"
                                            @click="
                                                openDriverRatingsModal(
                                                    driver.driver_id
                                                )
                                            "
                                        >
                                            View Ratings
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Start ratings tables -->
        <div v-if="showTripRatings" class="recent_orders">
            <h1>Trip Ratings</h1>
            <div class="table-container" v-if="showTripRatings">
                <div v-if="loading2" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!tripRatings.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>User ID</th>
                                    <th>Trip ID</th>
                                    <th>Rating</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(rating, index) in tripRatings"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ rating.user_id }}</td>
                                    <td>{{ rating.trip_id }}</td>
                                    <td>
                                        <span
                                            v-for="n in 5"
                                            :key="n"
                                            class="fa"
                                            :class="
                                                n <= rating.rating
                                                    ? 'fa-star'
                                                    : 'fa-star-o'
                                            "
                                        ></span>
                                    </td>
                                    <td>{{ rating.created_at }}</td>
                                    <td>{{ rating.updated_at }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="showDriverRatings" class="recent_orders">
            <h1>Driver Ratings</h1>
            <div class="table-container" v-if="showDriverRatings">
                <div v-if="loading3" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!driverRatings.length > 0"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Driver ID</th>
                                    <th>Rating</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(rating, index) in driverRatings"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>
                                        <span
                                            v-for="star in 5"
                                            :key="star"
                                            class="fa"
                                            :class="{
                                                'fa-star':
                                                    star <= rating.rating,
                                                'fa-star-o':
                                                    star > rating.rating,
                                            }"
                                        ></span>
                                    </td>
                                    <td>{{ rating.created_at }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for trip ratings -->
        <div v-if="showTripRatingsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Trip Ratings</h2>
                    <span class="close" @click="closeTripRatingsModal"
                        >&times;</span
                    >
                </div>
                <div class="modal-body">
                    <div v-if="loading4" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!tripRatingsDetails.length > 0"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>User ID</th>
                                        <th>Rating</th>
                                        <th>Comment</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            rating, index
                                        ) in tripRatingsDetails"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>
                                            <span
                                                v-for="star in 5"
                                                :key="star"
                                                class="fa"
                                                :class="{
                                                    'fa-star':
                                                        star <= rating.rating,
                                                    'fa-star-o':
                                                        star > rating.rating,
                                                }"
                                            ></span>
                                        </td>
                                        <td>{{ rating.comment }}</td>
                                        <td>{{ rating.created_at }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for driver ratings -->
        <div v-if="showDriverRatingsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Driver Ratings</h2>
                    <span class="close" @click="closeDriverRatingsModal"
                        >&times;</span
                    >
                </div>
                <div class="modal-body">
                    <div v-if="loading5" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!driverRatingsDetails.length > 0"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>User ID</th>
                                        <th>Rating</th>
                                        <th>Comment</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            rating, index
                                        ) in driverRatingsDetails"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>
                                            <span
                                                v-for="star in 5"
                                                :key="star"
                                                class="fa"
                                                :class="{
                                                    'fa-star':
                                                        star <= rating.rating,
                                                    'fa-star-o':
                                                        star > rating.rating,
                                                }"
                                            ></span>
                                        </td>
                                        <td>{{ rating.comment }}</td>
                                        <td>{{ rating.created_at }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End modal -->
    </div>
</template>

<script>
import axios from "axios";

export default {
    name: "GetAllRating",
    data() {
        return {
            loading: true,
            loading1: true,
            loading2: true,
            loading3: true,
            loading4: true,
            loading5: true,

            showTripRatings: false,
            showDriverRatings: false,
            showAllTrips: false,
            showAllDrivers: false,
            showTripRatingsModal: false,
            showDriverRatingsModal: false,
            tripRatings: [],
            driverRatings: [],
            Trips: [],
            Drivers: [],
            tripRatingsDetails: [],
            driverRatingsDetails: [],
        };
    },
    methods: {
        toggleTripRatings() {
            this.showTripRatings = true;
            this.showDriverRatings = false;
            this.showAllTrips = false;
            this.showAllDrivers = false;
            this.fetchTripRatings();
        },
        toggleDriverRatings() {
            this.showTripRatings = false;
            this.showDriverRatings = true;
            this.showAllTrips = false;
            this.showAllDrivers = false;
            this.fetchDriverRatings();
        },
        toggleAllTrips() {
            this.showTripRatings = false;
            this.showDriverRatings = false;
            this.showAllTrips = true;
            this.showAllDrivers = false;
            this.AllTrips();
        },
        toggleAllDrivers() {
            this.showTripRatings = false;
            this.showDriverRatings = false;
            this.showAllTrips = false;
            this.showAllDrivers = true;
            this.AllDriver();
        },
        fetchTripRatings() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_trip_rating",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.tripRatings = response.data;
                    this.loading2 = false;
                })
                .catch((error) => {
                    console.error("Error fetching trip ratings:", error);
                });
            this.loading2 = true;
        },
        fetchDriverRatings() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver_rating",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverRatings = response.data;
                    this.loading3 = false;
                })
                .catch((error) => {
                    console.error("Error fetching driver ratings:", error);
                });
            this.loading3 = true;
        },
        fetchTripRatingsByTripId(trip_id) {
            this.showTripRatingsModal = true;
            this.showTripRatingsModal = true;

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/all_trip_rating_by_trip_id/${trip_id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.tripRatingsDetails = response.data;
                    this.loading4 = false;
                })
                .catch((error) => {
                    console.error(
                        "Error fetching trip ratings by trip ID:",
                        error
                    );
                });
            this.loading4 = true;
        },
        fetchDriverRatingsByDriverId(driver_id) {
            this.showDriverRatingsModal = true;

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/all_driver_rating_by_driver_id/${driver_id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverRatingsDetails = response.data;
                    this.loading5 = false;
                })
                .catch((error) => {
                    console.error(
                        "Error fetching driver ratings by driver ID:",
                        error
                    );
                });
            this.loading5 = true;
        },
        AllTrips() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_trips",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Trips = response.data;
                    console.log(response.data);
                    this.loading = false;
                })
                .catch((error) => {
                    console.error("Error Getting Trips:", error);
                });
            this.loading = true;
        },
        AllDriver() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Drivers = response.data;
                    console.log(response.data);
                    this.loading1 = false;
                })
                .catch((error) => {
                    console.error("Error getting drivers:", error);
                });
            this.loading1 = true;
        },
        openTripRatingsModal(tripId) {
            this.fetchTripRatingsByTripId(tripId);
        },
        closeTripRatingsModal() {
            this.showTripRatingsModal = false;
        },
        openDriverRatingsModal(driverId) {
            this.fetchDriverRatingsByDriverId(driverId);
        },
        closeDriverRatingsModal() {
            this.showDriverRatingsModal = false;
        },
    },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap");

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
    --box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.dark-theme-variables {
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --box-shadow: 0 2rem 3rem var(--clr-light);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
}

.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh; /* تجعل الـ spinner يأخذ كامل الشاشة */
}

.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px; /* Adjust as needed */
    font-size: 1.2rem;
    color: var(--clr-dark-variant);
    text-align: center;
    border: 1px solid var(--clr-light);
    border-radius: var(--border-radius-2);
    background-color: var(--clr-color-background);
}

.spinner {
    border: 4px solid var(--clr-light);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
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
}

h2 {
    font-size: 1.4rem;
}

.recent_orders {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.recent_orders h1 {
    margin: var(--padding-1);
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: var(--border-radius-2);
    padding: var(--padding-1);
    text-align: center;
    box-shadow: 0 1rem 1.5rem var(--clr-light);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
}

.recent_orders table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: var(--padding-1);
    font-size: 0.9rem;
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
    transition: background-color 0.3s ease;
}

table tbody tr:hover {
    background-color: var(--clr-light);
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}

table tbody tr:last-child td {
    border: none;
}

/* Select styling */
select {
    padding: var(--padding-1);
    border: 1px solid var(--clr-primary);
    border-radius: var(--border-radius-1);
    background-color: var(--clr-white);
    color: var(--clr-dark);
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: var(--clr-primary-variant);
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}

/* Button styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: var(--clr-white);
    border-radius: var(--border-radius-3);
    width: 100%;
    max-width: 800px;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 15px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
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

/* Modal styling */
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
    background: var(--clr-white);
    padding: var(--padding-1);
    border-radius: var(--border-radius-2);
    max-width: 400px;
    width: 70%;
    box-shadow: var(--box-shadow);
    text-align: center;
    margin-top: 2rem;
    margin-left: 10rem;
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--padding-1);
}

.modal-header h2 {
    margin: 0;
}

.close {
    cursor: pointer;
    font-size: 1.5rem;
}

.fa-star,
.fa-star-o {
    color: #ffd700; /* gold color for the stars */
}

.status-btn.view-ratings-btn {
    background-color: var(--clr-primary);
    color: var(--clr-white);
    padding: 5px 10px;
    border: none;
    border-radius: var(--border-radius-1);
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.status-btn.view-ratings-btn:hover {
    background-color: var(--clr-primary-variant);
}
</style>
