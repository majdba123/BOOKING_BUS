<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="fetchPrivateTrips">
                Load Private Trips
            </button>
            <button class="nav-btnd" @click="fetchMyOrders">My Orders</button>
        </header>

        <!-- Display orders if showOrders is true -->
        <div v-if="showOrders && myOrders.length" class="form-containerd">
            <div class="table-container">
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
                        <tr v-for="order in paginatedOrders" :key="order.id">
                            <td>{{ order.id }}</td>
                            <td>{{ order.private_trip.from }}</td>
                            <td>{{ order.private_trip.to }}</td>
                            <td>{{ order.price }}</td>
                            <td>{{ order.status }}</td>
                        </tr>
                    </tbody>
                </table>
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
                            <td>{{ trip.id }}</td>
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
                    this.showOrders = false; // Hide orders and show private trips
                    this.showForm = true; // Show private trips form
                })
                .catch((error) => {
                    this.toast.error("Error fetching private trips.");
                    console.error(error);
                });
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
    margin-top: 20px;
}

.table-container {
    width: 100%;
}

.table-container table {
    width: 100%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    color: #363949;
    max-width: none;
    font-size: 0.85rem;
}

.table-container table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid #fff;
    color: #677483;
    transition: background-color 0.3s ease;
}

table tbody tr:hover {
    background-color: #f1f1f1;
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid #363949;
    color: #677483;
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
    color: white;
    margin: 0 5px;
    background-color: #007bff;
    font-size: 12px;
    font-weight: bold;
}
.accept-btn .material-icons {
    font-size: 16px;
    margin-right: 4px;
}

.accept-btn:hover {
    background-color: #0056b3;
    transform: scale(1.05);
    box-shadow: 0 0 10px rgba(0, 91, 187, 0.5);
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
    background-color: #007bff;
    color: white;
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
    color: #363949;
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
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    width: 100%;
    max-width: 800px;
    margin: 20px;
    padding: 10px;
    flex-wrap: wrap;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: 25px;
    background: linear-gradient(90deg, #7380ec 0%, #007bff 100%);
    color: white;
    cursor: pointer;
    font-size: 12px;
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
    background: #fff;
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
    background-color: #c9302c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 5px;
}

.close-modal:hover {
    background-color: #d9534f;
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
