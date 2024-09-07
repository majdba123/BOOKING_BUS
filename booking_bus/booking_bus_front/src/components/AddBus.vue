<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">Add Bus</button>
            <button class="nav-btnd" @click="showForm = false">Edit Bus</button>
            <button class="nav-btnd" @click="showBusStatusModal = true">
                Bus Status
            </button>
        </header>

        <!-- Add Bus Form -->
        <div v-if="showForm" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="numberBus">Number Bus</label>
                    <input
                        type="text"
                        id="numberBus"
                        v-model="number_bus"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberPassenger">Number Passenger</label>
                    <input
                        type="text"
                        id="numberPassenger"
                        v-model="number_passenger"
                        required
                    />
                </div>

                <div class="submit-btnnd">
                    <button type="submit" @click="AddBus" class="submit-btnd">
                        Submit
                    </button>
                </div>
            </form>
        </div>

        <!-- Bus Table -->
        <div v-else class="recent_orders">
            <h1>All Bus</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!paginatedBuses.length" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Number Bus</th>
                                    <th>Number Passenger</th>
                                    <th>Actions</th>
                                    <th>Seats</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(bus, index) in paginatedBuses"
                                    :key="index"
                                >
                                    <td>{{ bus.number_bus }}</td>
                                    <td>{{ bus.number_passenger }}</td>
                                    <td>
                                        <button
                                            class="edit-btn"
                                            @click="openEditModal(bus, index)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                        <button
                                            class="delete-btn"
                                            @click="confirmDeleteBus(bus)"
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="status-btn"
                                            @click="
                                                openSeatsModal(bus.id, index)
                                            "
                                        >
                                            <span class="material-icons"
                                                >visibility</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <button
                                :disabled="currentPage === 1"
                                @click="changePage(currentPage - 1)"
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
                                :disabled="currentPage === totalPages"
                                @click="changePage(currentPage + 1)"
                            >
                                <span class="material-icons">skip_next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bus Status Modal -->
        <div v-if="showBusStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Bus Status</div>
                <button class="status-btns" @click="fetchBusStatus('pending')">
                    Pending
                </button>
                <button
                    class="status-btns"
                    @click="fetchBusStatus('available')"
                >
                    Available
                </button>
                <button class="status-btns" @click="fetchBusStatus('finished')">
                    Finished
                </button>
                <div class="modal-body">
                    <div v-if="loading1" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!paginatedBusStatusData.length"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Number Bus</th>
                                        <th>Number Passenger</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            bus, index
                                        ) in paginatedBusStatusData"
                                        :key="index"
                                    >
                                        <td>{{ bus.number_bus }}</td>
                                        <td>{{ bus.number_passenger }}</td>
                                        <td>{{ bus.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="pagination">
                            <button @click="prevPage('busStatus')">
                                <span class="material-icons"
                                    >skip_previous</span
                                >
                            </button>
                            <span
                                >Page {{ currentPageBusStatus }} of
                                {{ totalPagesBusStatus }}</span
                            >
                            <button @click="nextPage('busStatus')">
                                <span class="material-icons">skip_next</span>
                            </button>
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

        <!-- Bus Seats Modal -->
        <div v-if="showSeatsModal" class="modal">
            <div class="modal-contentseat">
                <div class="modal-header">
                    Bus Seats (Total: {{ seats.length }})
                </div>
                <div class="modal-body">
                    <div class="seats-container">
                        <div
                            v-for="(seat, index) in seats"
                            :key="seat.seat_id"
                            :class="[
                                'seat',
                                seat.status === 2 ? 'occupied' : '',
                                'seat' + (index + 1),
                            ]"
                        >
                            <span class="material-icons"
                                >airline_seat_recline_normal</span
                            >
                            {{ seat.seat_number }}
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeSeatsModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Edit Bus Modal -->
        <div v-if="showEditModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Bus</div>
                <div class="modal-body">
                    <div class="form-groupd">
                        <label for="editNumberBus">Number Bus</label>
                        <input
                            type="text"
                            id="editNumberBus"
                            v-model="editedBus.number_bus"
                            required
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="editNumberPassenger"
                            >Number Passenger</label
                        >
                        <input
                            type="text"
                            id="editNumberPassenger"
                            v-model="editedBus.number_passenger"
                            required
                        />
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="updateBus" class="update-btn">Save</button>
                    <button @click="closeEditModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Confirm Delete Modal -->
        <div v-if="showDeleteConfirmModal" class="modals">
            <div class="modals-content">
                <div class="modals-header">Confirm Delete</div>
                <div class="modals-body">
                    Are you sure about the deletion process?
                </div>
                <div class="modals-footer">
                    <button @click="deleteConfirmedBus" class="updates-btn">
                        Yes
                    </button>
                    <button
                        @click="closeDeleteConfirmModal"
                        class="closes-modal"
                    >
                        No
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import store from "@/store";
import { useToast } from "vue-toastification";
import { debounce } from "lodash";

export default {
    data() {
        return {
            loading: true,
            loading1: false,
            showForm: true,
            Bus: [],
            busStatusData: [],
            seats: [],
            number_bus: "",
            number_passenger: "",
            showBusStatusModal: false,
            showSeatsModal: false,
            showEditModal: false,
            showDeleteConfirmModal: false,
            busToDelete: null,
            editedBus: {
                id: "",
                number_bus: "",
                number_passenger: "",
            },
            editingIndex: null,
            toast: useToast(),
            refreshInterval: null,
            currentPage: 1,
            itemsPerPage: 8,
            currentPageBusStatus: 1,
            searchQueryBusStatus: "",
        };
    },
    mounted() {
        this.AllBus();
    },
    methods: {
        closeBusStatusModal() {
            this.showBusStatusModal = false;
        },
        closeSeatsModal() {
            this.showSeatsModal = false;
            this.stopAutoRefresh();
        },
        closeEditModal() {
            this.showEditModal = false;
        },
        handleSubmit() {
            console.log(
                "Form Submitted",
                this.number_bus,
                this.number_passenger
            );
        },
        AddBus() {
            const token = window.localStorage.getItem("access_token");

            axios
                .post(
                    "http://127.0.0.1:8000/api/company/store_bus",
                    {
                        number_bus: this.number_bus.toString(),
                        number_passenger: this.number_passenger.toString(),
                    },
                    {
                        headers: { Authorization: `Bearer ${token}` },
                    }
                )
                .then((response) => {
                    console.log(response);
                    this.toast.success("Bus added successfully!");
                    this.AllBus();
                })
                .catch((error) => {
                    this.toast.error("Error adding bus.");
                    console.log(error);
                });
        },
        updateBus() {
            const access_token = window.localStorage.getItem("access_token");
            const busId = this.editedBus.id;

            axios
                .put(
                    `http://127.0.0.1:8000/api/company/update_bus/${busId}`,
                    {
                        number_bus: this.editedBus.number_bus.toString(),
                        number_passenger:
                            this.editedBus.number_passenger.toString(),
                    },
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    this.Bus.splice(this.editingIndex, 1, this.editedBus);
                    this.editingIndex = null;
                    this.editedBus = {
                        id: "",
                        number_bus: "",
                        number_passenger: "",
                    };
                    console.log(response);

                    this.toast.success("Bus updated successfully!");
                    this.showEditModal = false;
                })
                .catch((error) => {
                    console.log(this.editedBus);

                    this.toast.error("Error updating bus.");
                    console.error(error);
                });
        },
        AllBus() {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .get("http://127.0.0.1:8000/api/company/all_bus", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.Bus = response.data;
                    store.state.Bus = response.data;
                    this.loading = false;
                })
                .catch((error) => {
                    window.alert("Error Getting Bus");
                    console.error(error);
                });
            this.loading = true;
        },
        fetchBusStatus(status) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .get(
                    `http://127.0.0.1:8000/api/company/get_bus_status?status=${status}`,
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    this.busStatusData = response.data;
                    this.loading1 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching bus status");
                    console.error(error);
                });
            this.loading1 = true;
        },
        openEditModal(bus, index) {
            this.editedBus = { ...bus };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        confirmDeleteBus(bus) {
            console.log("Bus selected for deletion:", bus);
            this.busToDelete = bus;
            this.showDeleteConfirmModal = true;
        },
        deleteConfirmedBus() {
            if (this.busToDelete && this.busToDelete.id) {
                console.log("Deleting bus:", this.busToDelete);
                this.DeleteBus(this.busToDelete.id);
            } else {
                console.error("No bus selected for deletion.");
            }
            this.closeDeleteConfirmModal();
        },
        DeleteBus(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .delete(`http://127.0.0.1:8000/api/company/delete_bus/${id}`, {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then(() => {
                    this.Bus = this.Bus.filter((busItem) => busItem.id !== id);
                    this.toast.success("Bus deleted successfully");
                    this.AllBus();
                })
                .catch((error) => {
                    console.error("Error during deletion:", error);
                    this.toast.error("Error deleting bus");
                });
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
            this.busToDelete = null;
        },
        openSeatsModal(busId, index) {
            console.log(
                `Opening seats modal for busId: ${busId}, index: ${index}`
            );
            this.fetchSeats(busId, index);
            this.startAutoRefresh(busId, index);
        },
        fetchSeats: debounce(function (busId, index) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .post(
                    `http://127.0.0.1:8000/api/company/all_seat_of_bus/${busId}`,
                    {},
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    console.log("Fetched seats:", response.data);
                    this.Bus[index].seats = response.data;
                    this.seats = response.data;
                    this.showSeatsModal = true;
                })
                .catch((error) => {
                    window.alert("Error fetching bus seats");
                    console.error("Fetch seats error:", error);
                });
        }, 300),
        startAutoRefresh(busId, index) {
            console.log("Starting auto-refresh...");
            this.stopAutoRefresh();

            this.refreshInterval = setInterval(() => {
                console.log("Fetching seats...");
                this.fetchSeats(busId, index);
            }, 10000);
        },
        stopAutoRefresh() {
            console.log("Stopping auto-refresh...");
            if (this.refreshInterval) {
                clearInterval(this.refreshInterval);
                this.refreshInterval = null;
            }
        },
        changePage(page) {
            if (page < 1 || page > this.totalPages) return;
            this.currentPage = page;
        },
        prevPage(modalType) {
            if (modalType === "busStatus") {
                if (this.currentPageBusStatus > 1) {
                    this.currentPageBusStatus--;
                }
            } else if (modalType === "bus") {
                if (this.currentPage > 1) {
                    this.currentPage--;
                }
            }
        },
        nextPage(modalType) {
            if (modalType === "busStatus") {
                if (this.currentPageBusStatus < this.totalPagesBusStatus) {
                    this.currentPageBusStatus++;
                }
            } else if (modalType === "bus") {
                if (this.currentPage < this.totalPages) {
                    this.currentPage++;
                }
            }
        },
    },
    computed: {
        filteredBusStatusData() {
            if (!this.searchQueryBusStatus) {
                return this.busStatusData;
            }
            return this.busStatusData.filter((bus) => {
                const searchQuery = this.searchQueryBusStatus.toLowerCase();
                return bus.number_bus
                    .toString()
                    .toLowerCase()
                    .includes(searchQuery);
            });
        },
        paginatedBusStatusData() {
            const start = (this.currentPageBusStatus - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.filteredBusStatusData.slice(start, end);
        },
        totalPagesBusStatus() {
            return Math.ceil(
                this.filteredBusStatusData.length / this.itemsPerPage
            );
        },
        filteredBuses() {
            return store.state.Bus.filter((bus) => {
                const searchQuery = store.state.searchQuery.toLowerCase();
                return bus.number_bus
                    .toString()
                    .toLowerCase()
                    .includes(searchQuery);
            });
        },
        paginatedBuses() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.filteredBuses.slice(start, end);
        },
        totalPages() {
            return Math.ceil(this.filteredBuses.length / this.itemsPerPage);
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

/* Typography */
body {
    font-family: "Roboto", sans-serif;
    width: 100%;
    height: 100%;
    font-size: 0.88rem;
    background: var(--clr-color-background);
    overflow-y: auto;
}

h1 {
    font-weight: 700;
    font-size: 2rem;
    color: var(--clr-dark);
}

h2 {
    font-weight: 500;
    font-size: 1.6rem;
    color: var(--clr-dark);
}

h3 {
    font-weight: 500;
    font-size: 1.4rem;
    color: var(--clr-dark);
}

h4 {
    font-weight: 400;
    font-size: 1.2rem;
    color: var(--clr-dark);
}

p {
    font-weight: 400;
    font-size: 1rem;
    color: var(--clr-dark-variant);
}

small {
    font-weight: 400;
    font-size: 0.8rem;
    color: var(--clr-dark-variant);
}

/* Table styling */
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
    border-radius: var(--border-radius-2);
    padding: var(--card-padding);
    text-align: center;
    box-shadow: 0 1rem 1.5rem var(--clr-light);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
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
    color: var(--clr-dark-variant);
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background-color: var(--clr-color-background);
}

.recent_orders table:hover {
    box-shadow: none;
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
.edit-btn.material-icons,
.delete-btn.material-icons,
.status-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 8px;
    border-radius: 9px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 15px;
    width: 15px;
}

.edit-btn.material-icons,
.delete-btn.material-icons,
.status-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 8px;
    border-radius: 9px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 15px;
    width: 15px;
}

.edit-btn {
    color: #4caf50;
    background-color: var(--clr-white);
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}
.edit-btn:hover {
    color: var(--clr-white);
    background-color: var(--clr-success);
}
.delete-btn {
    color: #f44336;
    background-color: var(--clr-white);
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}

.delete-btn:hover {
    color: #fff;
    background-color: #f44336;
}

.status-btn {
    border-radius: 9px;
    background-color: var(--clr-primary);
    transition: background-color 0.3s ease, transform 0.2s;
    color: var(--clr-white);
    width: 30px;
}

.status-btn:hover {
    background-color: var(--clr-primary-variant);
}
.status-btns {
    border-radius: 9px;
    background-color: var(--clr-primary);
    transition: background-color 0.3s ease, transform 0.2s;
    color: var(--clr-white);
    margin: 10px;
    padding: 10px;
}

.status-btns:hover {
    background-color: var(--clr-primary-variant);
}

/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: var(--clr-white);
    border-radius: 10px;
    width: 100%;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    width: 100%;
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

/* Form and Map styling */
.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 20px;
    background-color: rgba(var(--clr-white), 0.9);
    box-shadow: 0 2rem 3rem var(--clr-light);
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
    color: var(--clr-dark);
}

input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
}

input:focus {
    border-color: var(--clr-primary-variant);
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
    height: 86%;
    overflow-y: scroll;
    scrollbar-width: none;
    margin: 10px;
}

.modal-content::-webkit-scrollbar {
    display: none;
}

.modal-header,
.modal-body div div {
    margin-bottom: 10px;
    display: flex;
    justify-content: center;
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

.modal-body div div table {
    width: 100%;
    border-collapse: collapse;
}

.modal-body div div table th,
.modal-body div div table td {
    text-align: center;
    vertical-align: middle;
    padding: 8px;
}

.modal-body div div table tbody tr {
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-body div div table thead {
    display: flex;
    justify-content: center;
}

.modal-body div div table tbody {
    display: flex;
    flex-direction: column;
}

.modal-body div div table tr {
    width: 100%;
    display: flex;
    justify-content: space-evenly;
}

.modal-body div div table td {
    flex: 1;
}

.close-modal {
    padding: 8px 16px;
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.close-modal:hover {
    background-color: #c9302c;
}

.update-btn {
    padding: 8px 16px;
    background-color: var(--clr-success);
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-right: 10px;
}

.update-btn:hover {
    background-color: #4cae4c;
}

.modals {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}

.modals-content {
    background: var(--clr-white);
    color: var(--clr-dark);
    padding: 15px;
    border-radius: 10px;
    max-width: 400px;
    width: 50%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    text-align: center;
}

.modals-header {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 15px;
}

.modals-body {
    margin-bottom: 20px;
}

.modals-footer {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.updates-btn,
.closes-modal {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.updates-btn {
    background-color: #4caf50;
    color: #fff;
}

.updates-btn:hover {
    background-color: #3c8f3c;
}

.closes-modal {
    background-color: #f44336;
    color: #fff;
}

.closes-modal:hover {
    background-color: #c9302c;
}

/* Seats styling */
.seats-container {
    display: grid;
    grid-template-columns: 1fr 1fr 50px 1fr 1fr;
    gap: 10px;
    justify-content: center;
    width: 250px;
    height: 300px;
    overflow-y: scroll;
    overflow-x: hidden;
    scrollbar-width: none;
}

.modal-contentseat {
    background: var(--clr-white);
    padding: 20px;
    border-radius: 10px;
    max-width: 350px;
    width: 80%;
    box-shadow: 0 2rem 3rem var(--clr-light);
}

.seat {
    width: 30px;
    height: 30px;
    color: var(--clr-primary);
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    font-size: 0.8rem;
    transition: transform 0.2s, box-shadow 0.2s;
}

.seat:nth-child(4n + 1) {
    grid-column: 1;
}

.seat:nth-child(4n + 2) {
    grid-column: 2;
}

.seat:nth-child(4n + 3) {
    grid-column: 4;
}

.seat:nth-child(4n + 4) {
    grid-column: 5;
}

.seat:hover {
    transform: scale(1.1);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.seat.occupied {
    background-color: var(--clr-danger);
    color: var(--clr-white);
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
