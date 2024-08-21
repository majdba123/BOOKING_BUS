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

        <div v-else class="recent_orders">
            <h1>All Bus</h1>
            <div class="table-container">
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
                        <tr v-for="(bus, index) in filteredBuses" :key="index">
                            <td>{{ bus.number_bus }}</td>
                            <td>{{ bus.number_passenger }}</td>
                            <td>
                                <button
                                    class="edit-btn"
                                    @click="openEditModal(bus, index)"
                                >
                                    <span class="material-icons">edit</span>
                                </button>
                                <button
                                    class="delete-btn"
                                    @click="DeleteBus(bus.id)"
                                >
                                    <span class="material-icons">delete</span>
                                </button>
                            </td>

                            <td>
                                <button
                                    class="status-btn"
                                    @click="showSeats(bus.id)"
                                >
                                    <span class="material-icons"
                                        >visibility</span
                                    >
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

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
                    <button
                        class="status-btn"
                        @click="fetchBusStatus('pending')"
                    >
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchBusStatus('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchBusStatus('completed')"
                    >
                        Complated
                    </button>
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
                                v-for="(bus, index) in busStatusData"
                                :key="index"
                            >
                                <td>{{ bus.number_bus }}</td>
                                <td>{{ bus.number_passenger }}</td>
                                <td>{{ bus.status }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button @click="closeBusStatusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <div v-if="showSeatsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Bus Seats</div>
                <div class="modal-body">
                    <div class="seats-container">
                        <div
                            v-for="seat in seats"
                            :key="seat.seat_id"
                            class="seat"
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
    </div>
</template>

<script>
import axios from "axios";
import store from "@/store";
import { useToast } from "vue-toastification";

export default {
    name: "AddBus",
    data() {
        return {
            showForm: true,
            Bus: [],
            busStatusData: [],
            seats: [],
            number_bus: "",
            number_passenger: "",
            showBusStatusModal: false,
            showSeatsModal: false,
            showEditModal: false,
            editedBus: {
                id: "",
                number_bus: "",
                number_passenger: "",
            },
            editingIndex: null,
            toast: useToast(),
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

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/store_bus",
                data: {
                    number_bus: this.number_bus.toString(),
                    number_passenger: this.number_passenger.toString(),
                },
                headers: { Authorization: `Bearer ${token}` },
            })
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
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/update_bus/${busId}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    number_bus: this.editedBus.number_bus.toString(),
                    number_passenger:
                        this.editedBus.number_passenger.toString(),
                },
            })
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
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Bus = response.data;
                    store.state.Bus = response.data;
                    console.log(response.data);
                })
                .catch(function (error) {
                    window.alert("Error Getting Bus");
                    console.error(error);
                });
        },
        fetchBusStatus(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: ` http://127.0.0.1:8000/api/company/get_bus_status?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.busStatusData = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching bus status");
                    console.error(error);
                });
        },
        openEditModal(bus, index) {
            this.editedBus = { ...bus };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        DeleteBus(id) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_bus/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.Bus = this.Bus.filter((busItem) => busItem.id !== id);
                    this.toast.success("Bus deleted successfully!");
                }, this.AllBus())
                .catch((error) => {
                    this.toast.error("Error deleting bus.");
                    console.error(error);
                });
        },
        showSeats(busId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/all_seat_of_bus/${busId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.seats = response.data;
                    this.showSeatsModal = true;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching bus seats");
                    console.error(error);
                });
        },
    },
    computed: {
        filteredBuses() {
            return store.state.Bus.filter((bus) => {
                return bus.number_bus
                    .toString()
                    .toLowerCase()
                    .includes(store.state.searchQuery.toLowerCase());
            });
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
    background-color: #fff;
    width: 100%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1rem 1.5rem rgba(132, 139, 200, 0.18);
    color: #363949;
    max-width: none;
    font-size: 0.85rem;
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
    height: 15px;
    width: 15px;
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

.status-btn {
    border-radius: 9px;
    background-color: #007bff;
    transition: background-color 0.3s ease, transform 0.2s;
    color: white;
    width: 30px;
}

.status-btn:hover {
    background-color: #0056b3;
}
.status-btns {
    border-radius: 9px;
    background-color: #007bff;
    transition: background-color 0.3s ease, transform 0.2s;
    color: white;
    margin: 10px;
    padding: 10px;
}
.status-btns:hover {
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
    border-radius: 10px;
    width: 100%;
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
    background: #fff;
    padding: 20px;
    border-radius: 10px;
    max-width: 500px;
    width: 80%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.modal-header,
.modal-body {
    margin-bottom: 10px;
    display: flex;
    justify-content: center;
}

.modal-header {
    font-size: 1.2rem;
    font-weight: bold;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
}
.modal-body table {
    width: 100%;
    border-collapse: collapse;
}

.modal-body table th,
.modal-body table td {
    text-align: center;
    vertical-align: middle;
    padding: 8px;
}

.modal-body table tbody tr {
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-body table thead {
    display: flex;
    justify-content: center;
}

.modal-body table tbody {
    display: flex;
    flex-direction: column;
}

.modal-body table tr {
    width: 100%;
    display: flex;
    justify-content: space-evenly;
}

.modal-body table td {
    flex: 1;
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
