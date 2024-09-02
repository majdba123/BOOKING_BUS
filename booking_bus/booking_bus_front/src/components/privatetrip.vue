<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="fetchPrivateTrips">
                Load Private Trips
            </button>
            <button class="nav-btnd" @click="fetchMyOrders">My Orders</button>
        </header>

        <div v-if="showOrders && myOrders.length" class="form-containerd">
            <div class="table-container" v-if="privateTrips">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!privateTrips.length > 0"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Starting Area</th>
                                    <th>End Area</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="order in paginatedOrders"
                                    :key="order.id"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ order.private_trip.from }}</td>
                                    <td>{{ order.private_trip.to }}</td>
                                    <td>{{ order.price }}</td>
                                    <td>{{ order.status }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div v-if="totalOrderPages > 1" class="pagination">
                        <button
                            @click="prevOrderPage"
                            :disabled="currentOrderPage === 1"
                        >
                            <span class="material-icons"> skip_previous </span>
                        </button>
                        <span
                            >Page {{ currentOrderPage }} of
                            {{ totalOrderPages }}</span
                        >
                        <button
                            @click="nextOrderPage"
                            :disabled="currentOrderPage === totalOrderPages"
                        >
                            <span class="material-icons"> skip_next </span>
                        </button>
                    </div>
                    <!-- Display orders if showOrders is true -->
                </div>
            </div>
        </div>

        <!-- Display private trips if showForm is true -->
        <div v-if="showForm && privateTrips.length" class="form-containerd">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Trip ID</th>
                            <th>Starting Area</th>
                            <th>End Area</th>
                            <th>Distance</th>
                            <th>Date</th>
                            <th>Start Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="trip in paginatedTrips" :key="trip.id">
                            <td>{{ index }}</td>
                            <td>{{ trip.from }}</td>
                            <td>{{ trip.to }}</td>
                            <td>{{ trip.Distance }}</td>
                            <td>{{ trip.date }}</td>
                            <td>{{ trip.start_time }}</td>
                            <td>{{ trip.status }}</td>
                            <td>
                                <button
                                    class="accept-btn"
                                    @click="openAcceptModal(trip.id)"
                                >
                                    <span class="material-icons"> check </span>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div v-if="totalPages > 1" class="pagination">
                    <button @click="prevPage" :disabled="currentPage === 1">
                        <span class="material-icons"> skip_previous </span>
                    </button>
                    <span>Page {{ currentPage }} of {{ totalPages }}</span>
                    <button
                        @click="nextPage"
                        :disabled="currentPage === totalPages"
                    >
                        <span class="material-icons"> skip_next </span>
                    </button>
                </div>
                <div v-else>
                    <p>No private trips available.</p>
                </div>
            </div>
        </div>
        <!-- Modal for accepting order -->
        <div v-if="showAcceptModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Accept Private Order</div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input
                            type="number"
                            id="price"
                            v-model="price"
                            required
                        />
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="submitAcceptOrder" class="close-modal">
                        Submit
                    </button>
                    <button @click="closeAcceptModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
    name: "PrivateTrip",
    data() {
        return {
            loading: true,

            showForm: true, // Indicates if private trips should be displayed
            showOrders: false, // Indicates if orders should be displayed
            privateTrips: [],
            myOrders: [],
            currentPage: 1,
            currentOrderPage: 1, // Page number for orders
            itemsPerPage: 14,
            showAcceptModal: false,
            price: 0,
            selectedTripId: null,
            toast: useToast(),
        };
    },
    mounted() {
        this.fetchPrivateTrips();
    },
    computed: {
        paginatedTrips() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.privateTrips.slice(start, end);
        },
        totalPages() {
            return Math.ceil(this.privateTrips.length / this.itemsPerPage);
        },
        paginatedOrders() {
            const start = (this.currentOrderPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.myOrders.slice(start, end);
        },
        totalOrderPages() {
            return Math.ceil(this.myOrders.length / this.itemsPerPage);
        },
    },
    methods: {
        fetchPrivateTrips() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/private_trips",
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    this.privateTrips = response.data;
                    this.loading = false;
                    console.log(this.privateTrips);

                    this.showOrders = false; // Hide orders and show private trips
                    this.showForm = true; // Show private trips form
                })
                .catch((error) => {
                    this.toast.error("Error fetching private trips.");
                    console.error(error);
                });
            this.loading = true;
        },
        fetchMyOrders() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/my_ordes_for_private_trip",
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    this.myOrders = response.data;
                    this.showOrders = true; // Show orders and hide private trips
                    this.showForm = false; // Hide private trips form
                })
                .catch((error) => {
                    this.toast.error("Error fetching orders.");
                    console.error(error);
                });
        },
        openAcceptModal(tripId) {
            this.selectedTripId = tripId;
            this.showAcceptModal = true;
        },
        submitAcceptOrder() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/accept_private_order/${this.selectedTripId}`,
                headers: { Authorization: `Bearer ${token}` },
                data: {
                    price: this.price,
                },
            })
                .then(() => {
                    this.toast.success("Order accepted successfully!");
                    this.showAcceptModal = false;
                    this.fetchPrivateTrips();
                })
                .catch((error) => {
                    this.toast.error("Error accepting order.");
                    console.error(error);
                });
        },
        closeAcceptModal() {
            this.showAcceptModal = false;
        },
        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        },
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
            }
        },
        goToPage(pageNumber) {
            if (pageNumber >= 1 && pageNumber <= this.totalPages) {
                this.currentPage = pageNumber;
            }
        },
        prevOrderPage() {
            if (this.currentOrderPage > 1) {
                this.currentOrderPage--;
            }
        },
        nextOrderPage() {
            if (this.currentOrderPage < this.totalOrderPages) {
                this.currentOrderPage++;
            }
        },
        goToOrderPage(pageNumber) {
            if (pageNumber >= 1 && pageNumber <= this.totalOrderPages) {
                this.currentOrderPage = pageNumber;
            }
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
    --clr-info-dark: #7d8da1;
    --clr-info-light: #e4e9f7;
    --clr-dark: #363949;
    --clr-warning: #ffbb55;
    --clr-light: rgba(132, 139, 200, 0.18);
    --clr-primary-variant: #111e88;
    --clr-dark-variant: #677483;
    --clr-color-background: #f6f6f9;

    --card-border-radius: 2rem;
    --border-radius-1: 0.4rem;
    --border-radius-2: 0.8rem;
    --border-radius-3: 1.2rem;

    --card-padding: 1.8rem;
    --padding-1: 1.2rem;

    box-shadow: 0 2rem 3rem var(--clr-light);
}

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

h2 {
    font-size: 1.4rem;
    color: var(--clr-dark);
}

.recent_orders {
    width: 100%;
    margin-top: 20px;
}

.table-container {
    width: 100%;
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
    height: 150px;
    font-size: 1.2rem;
    color: var(--clr-dark-variant);
    text-align: center;
    border: 1px solid var(--clr-dark-variant);
    border-radius: var(--border-radius-2);
    background-color: var(--clr-color-background);
}

.spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

.recent_orders div table {
    background-color: var(--clr-white);
}

.table-container table {
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

.recent_orders div div h1 {
    margin: 18px;
    color: var(--clr-dark);
}

.recent_orders div div {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: var(--border-radius-2);
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1rem 1.5rem var(--clr-light);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
}

.table-container table:hover {
    box-shadow: none;
}

.recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
    font-size: 0.85rem;
    color: var(--clr-primary);
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
    color: var(--clr-dark);
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

.accept-btn {
    padding: 4px 8px;
    border-radius: 4px;
    cursor: pointer;
    border: none;
    transition: background-color 0.3s ease, transform 0.2s;
    color: var(--clr-white);
    margin: 0 5px;
    background-color: var(--clr-success);
    font-size: 12px;
    font-weight: bold;
}

.accept-btn .material-icons {
    font-size: 16px;
    margin-right: 4px;
}

.accept-btn:hover {
    background-color: darken(var(--clr-success), 10%);
    transform: scale(1.05);
    box-shadow: 0 0 10px rgba(0, 255, 0, 0.5);
}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
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

/* Select styling */
select {
    padding: 8px;
    border: 1px solid var(--clr-primary);
    border-radius: 4px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: var(--clr-primary-variant);
    box-shadow: 0 0 5px var(--clr-primary-variant);
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
    color: var(--clr-white);
    margin: 0 5px;
}

.delete-btn {
    background-color: var(--clr-danger);
}

.delete-btn:hover {
    background-color: darken(var(--clr-danger), 10%);
}

.edit-btn {
    background-color: var(--clr-warning);
}

.edit-btn:hover {
    background-color: darken(var(--clr-warning), 10%);
}

.status-btn {
    background-color: var(--clr-primary);
    margin-bottom: 10px;
}

.status-btn:hover {
    background-color: darken(var(--clr-primary), 10%);
}

/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: var(--clr-white);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    width: 100%;
    max-width: 400px;
    flex-wrap: wrap;
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

.containerd {
    width: 100%;
    margin-left: 20px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-size: cover;
    min-height: 100vh;
    background: var(--clr-color-background);
}

/* Form and Map styling */

.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 20px;
    border-radius: 10px;
    width: 100%;
    margin-top: 50px;
    transition: background-color 0.3s ease;
}

.form-groupd {
    margin-bottom: 15px;
    width: 100%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: var(--clr-dark);
}

input {
    width: 100%;
    padding: 10px;
    border: 2px solid var(--clr-dark-variant);
    border-radius: 5px;
    transition: border-color 0.3s;
}

input:focus {
    border-color: var(--clr-primary);
}

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
    padding: 20px;
    border-radius: 10px;
    max-width: 500px;
    width: 80%;
    box-shadow: 0 2rem 3rem var(--clr-light);
}

.modal-header,
.modal-body,
.modal-footer {
    margin-bottom: 10px;
}

.modal-header {
    font-size: 1.2rem;
    font-weight: bold;
    color: var(--clr-dark);
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
}

.close-modal {
    padding: 8px 16px;
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 5px;
}

.close-modal:hover {
    background-color: darken(var(--clr-danger), 10%);
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
    background-color: var(--clr-primary);
    color: var(--clr-white);
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
    background-color: var(--clr-danger);
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .containerd {
        padding: 10px;
    }

    .navd {
        flex-direction: column;
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
}
</style>
