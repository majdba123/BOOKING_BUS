<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="toggleTripRatings">
                All Reservation
            </button>
            <button class="nav-btnd" @click="showReservationStatusModal = true">
                Reservation Status
            </button>
            <button class="nav-btnd" @click="toggleAllReservationTheBus">
                Reservation The Bus
            </button>
            <button class="nav-btnd" @click="toggleAllDrivers">
                All Drivers
            </button>
        </header>

        <!-- Start all trips table -->
        <div v-if="showAllReservationTheBus" class="recent_orders">
            <h1>All Reservation The Bus</h1>
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
                                <tr
                                    v-for="(trip, index) in paginatedTrips"
                                    :key="index"
                                >
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
                        <div class="pagination">
                            <button
                                @click="currentPageTrips--"
                                :disabled="currentPageTrips === 1"
                            >
                                <span class="material-icons"
                                    >skip_previous</span
                                >
                            </button>
                            <span
                                >Page {{ currentPageTrips }} of
                                {{ totalPagesTrips }}</span
                            >
                            <button
                                @click="currentPageTrips++"
                                :disabled="currentPageTrips === totalPagesTrips"
                            >
                                <span class="material-icons">skip_next</span>
                            </button>
                        </div>
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
                                    v-for="(driver, index) in paginatedDrivers"
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
                        <div class="pagination">
                            <button
                                @click="currentPageDrivers--"
                                :disabled="currentPageDrivers === 1"
                            >
                                <span class="material-icons"
                                    >skip_previous</span
                                >
                            </button>
                            <span
                                >Page {{ currentPageDrivers }} of
                                {{ totalPagesDrivers }}</span
                            >
                            <button
                                @click="currentPageDrivers++"
                                :disabled="
                                    currentPageDrivers === totalPagesDrivers
                                "
                            >
                                <span class="material-icons">skip_next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Start ratings tables -->
        <div v-if="showTripRatings" class="recent_orders">
            <h1>All Reservation</h1>
            <div class="table-container">
                <div v-if="loading2" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!AllReservation.length > 0"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Reservation ID</th>
                                    <th>Price</th>
                                    <th>Type</th>
                                    <th>User Name</th>
                                    <th>User ID</th>
                                    <th>Break</th>
                                    <th>From</th>
                                    <th>To</th>
                                    <th>ID Seat</th>
                                    <th>Status Seat</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(
                                        Reservation, index
                                    ) in paginatedReservations"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ Reservation.price }}</td>
                                    <td>{{ Reservation.type }}</td>
                                    <td>{{ Reservation.user_name }}</td>
                                    <td>{{ Reservation.user_id }}</td>
                                    <td>{{ Reservation.break }}</td>
                                    <td>{{ Reservation.from }}</td>
                                    <td>{{ Reservation.to }}</td>
                                    <td>{{ Reservation.seats[0].id }}</td>
                                    <td>{{ Reservation.seats[0].status }}</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <button
                                @click="currentPage--"
                                :disabled="currentPage === 1"
                            >
                                <span class="material-icons"
                                    >skip_previous</span
                                >
                            </button>
                            <span
                                >Page {{ currentPage }} of
                                {{ totalPages }}</span
                            >
                            <button
                                @click="currentPage++"
                                :disabled="currentPage === totalPages"
                            >
                                <span class="material-icons">skip_next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="showReservationStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Reservation Status</div>
                <div class="modal-body">
                    <button
                        class="status-btn"
                        @click="fetchReservationStatus('padding')"
                    >
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchReservationStatus('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchReservationStatus('completed')"
                    >
                        Complated
                    </button>
                    <div v-if="loading3" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!ReservationStatusData.length > 0"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>User Name</th>
                                        <th>Price</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            Reservation, index
                                        ) in ReservationStatusData"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>

                                        <td>{{ Reservation.user_name }}</td>

                                        <td>{{ Reservation.price }}</td>

                                        <td>{{ Reservation.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeBusStatusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <div v-if="showDriverRatings" class="recent_orders">
            <h1>Driver Ratings</h1>
            <div class="table-container">
                <div v-if="loading4" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!driverRatings > 0" class="no-data-message">
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
                    <div v-if="loading5" class="spinner-container">
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
                    <div v-if="loading6" class="spinner-container">
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
    name: "GetAllReservation",
    data() {
        return {
            showReservationStatusModal: false,
            loading: true,
            loading1: true,
            loading2: true,
            loading3: false,
            loading4: false,
            loading5: true,
            loading6: true,

            showTripRatings: true,
            showDriverRatings: false,
            showAllReservationTheBus: false,
            showAllDrivers: false,
            showTripRatingsModal: false,
            showDriverRatingsModal: false,
            AllReservation: [],
            driverRatings: [],
            Trips: [],
            Drivers: [],
            tripRatingsDetails: [],
            driverRatingsDetails: [],
            ReservationStatusData: [],
            currentPage: 1,
            itemsPerPage: 10,
            currentPageDrivers: 1,
            itemsPerPageDrivers: 10,
            currentPageTrips: 1,
            itemsPerPageTrips: 10,
        };
    },
    methods: {
        fetchReservationStatus(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: ` http://127.0.0.1:8000/api/company/all_reservation_by_status?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.ReservationStatusData = response.data;
                    console.log(response.data);
                    this.loading3 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching bus status");
                    console.error(error);
                });
            this.loading3 = true;
        },
        closeBusStatusModal() {
            this.showReservationStatusModal = false;
        },
        toggleTripRatings() {
            this.showTripRatings = true;
            this.showDriverRatings = false;
            this.showAllReservationTheBus = false;
            this.showAllDrivers = false;
            this.fetchReservation();
        },

        toggleAllReservationTheBus() {
            this.showTripRatings = false;
            this.showDriverRatings = false;
            this.showAllReservationTheBus = true;
            this.showAllDrivers = false;
            this.AllTrips();
        },
        toggleAllDrivers() {
            this.showTripRatings = false;
            this.showDriverRatings = false;
            this.showAllReservationTheBus = false;
            this.showAllDrivers = true;
            this.AllDriver();
        },
        fetchReservation() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_reservation",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.AllReservation = response.data;
                    this.loading2 = false;
                })
                .catch((error) => {
                    console.error("Error fetching trip ratings:", error);
                });
            this.loading2 = true;
        },
        fetchBusTrip(x) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/get_bus_trip/" + x,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.AllReservation = response.data;
                })
                .catch((error) => {
                    console.error("Error fetching trip ratings:", error);
                });
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
                })
                .catch((error) => {
                    console.error("Error fetching driver ratings:", error);
                });
        },
        fetchTripRatingsByTripId(trip_id) {
            this.showTripRatingsModal = true;

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/all_trip_rating_by_trip_id/${trip_id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.tripRatingsDetails = response.data;
                    this.loading5 = false;
                })
                .catch((error) => {
                    console.error(
                        "Error fetching trip ratings by trip ID:",
                        error
                    );
                });
            this.loading5 = true;
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
                    this.loading6 = false;
                })
                .catch((error) => {
                    console.error(
                        "Error fetching driver ratings by driver ID:",
                        error
                    );
                });
            this.loading6 = true;
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
    computed: {
        paginatedReservations() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.AllReservation.slice(start, end);
        },
        totalPages() {
            return Math.ceil(this.AllReservation.length / this.itemsPerPage);
        },
        paginatedTrips() {
            const start = (this.currentPageTrips - 1) * this.itemsPerPageTrips;
            const end = start + this.itemsPerPageTrips;
            return this.Trips.slice(start, end);
        },
        totalPagesTrips() {
            return Math.ceil(this.Trips.length / this.itemsPerPageTrips);
        },
        paginatedDrivers() {
            const start =
                (this.currentPageDrivers - 1) * this.itemsPerPageDrivers;
            const end = start + this.itemsPerPageDrivers;
            return this.Drivers.slice(start, end);
        },
        totalPagesDrivers() {
            return Math.ceil(this.Drivers.length / this.itemsPerPageDrivers);
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
    --padding-1: 1.2rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
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
    background-color: var(--clr-white);
    width: 100%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1rem 1.5rem rgba(132, 139, 200, 0.18);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
}

.recent_orders table:hover {
    box-shadow: none;
}
.spinner {
    border: 4px solid var(--clr-light);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh;
}

/* Add this part for the spinner rotation */
@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}
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
    background-color: var(--clr-white);
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid #fff;
    transition: background-color 0.3s ease;
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid #363949;
}

table tbody tr:last-child td {
    border: none;
}

/* Select styling */
select {
    padding: 8px;
    border: 1px solid #7380ec;
    border-radius: 4px;
    background-color: #fff;
    color: #363949;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: #007bff;
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}

/* Button styling */
.delete-btn,
.edit-btn,
.status-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    border: none;
    transition: background-color 0.3s ease, transform 0.2s;
    color: white;
    margin: 0 5px;
}

.delete-btn {
    background-color: #d9534f;
}

.delete-btn:hover {
    background-color: #c9302c;
}

.edit-btn {
    background-color: #f0ad4e;
}

.edit-btn:hover {
    background-color: #ec971f;
}

.status-btn {
    background-color: #007bff;
    margin-bottom: 10px;
}

.status-btn:hover {
    background-color: #0056b3;
}

/* Navigation styling */
.navd {
    margin-left: 4rem;

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

/* Form and Map styling */
.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    max-width: 400px;
    width: 100%;
    margin-top: 50px;
    margin: 40px auto;
}

.form-groupd {
    margin-bottom: 15px;
    width: 100%;
}

label {
    display: block;
    margin-bottom: 5px;
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
    transition: background-color 0.3s, transform 0.2s;
}

.submit-btnd:hover {
    background-color: #0056b3;
    transform: translateY(-3px);
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
    background-color: var(--clr-white);
    color: var(--clr-dark);
    padding: 20px;
    border-radius: 10px;
    max-width: 500px;
    width: 80%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.modal-header,
.modal-body,
.modal-footer {
    margin-bottom: 10px;
}

.modal-header {
    font-size: 1.2rem;
    font-weight: bold;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
}

.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.close-modal:hover {
    background-color: #c9302c;
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
    background-color: #4cae4c;
}

/* Seats styling */
.seats-container {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
    justify-content: center;
}

.seat {
    width: 50px;
    height: 50px;
    background-color: #007bff;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    font-size: 1rem;
    transition: transform 0.2s, box-shadow 0.2s;
}

.seat:hover {
    transform: scale(1.1);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.seat.occupied {
    background-color: #d9534f;
}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
    margin-bottom: 5px;
}

.pagination button {
    padding: 6px 10px;
    margin: 0 5px;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s;
}

.pagination button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
}

.pagination span {
    margin: 0 10px;
    font-size: 0.7rem;
    color: var(--clr-dark);
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .recent_orders table,
    .table-container {
        width: 100%;
        display: block;
    }

    .recent_orders table th,
    .recent_orders table td {
        font-size: 0.8rem;
        padding: 8px;
    }
    .containerd {
        padding: 10px;
    }

    .navd {
        flex-direction: column;
        margin: 0;
    }

    .nav-btnd {
        width: 100%;
        margin: 5px 0;
    }

    .form-containerd {
        width: 90%;
        padding: 15px;
    }

    .modal-content {
        width: 90%;
    }

    .seats-container {
        grid-template-columns: repeat(2, 1fr);
        gap: 5px;
    }

    .seat {
        width: 40px;
        height: 40px;
        font-size: 0.9rem;
    }
}

@media screen and (max-width: 480px) {
    .seats-container {
        grid-template-columns: 1fr;
    }

    .seat {
        width: 100%;
        height: 50px;
        font-size: 1rem;
    }
    .delete-btn,
    .edit-btn,
    .status-btn {
        padding: 6px 12px;
        font-size: 0.8rem;
        width: 100%;
        margin-bottom: 10px;
    }

    .pagination button {
        padding: 5px 8px;
        font-size: 0.7rem;
        margin: 0 3px;
    }
}
</style>
