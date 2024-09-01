<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">
                Add Driver
            </button>
            <button class="nav-btnd" @click="showForm = false">
                Edit Driver
            </button>
            <button class="nav-btnd" @click="showDriverStatusModal = true">
                Driver Status
            </button>
            <button class="nav-btnd" @click="fetchAllDriverWithBus">
                Drivers with Bus
            </button>
        </header>

        <div v-if="showForm" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="driverName">Driver Name</label>
                    <input
                        type="text"
                        id="driverName"
                        v-model="name"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverEmail">Email</label>
                    <input
                        type="email"
                        id="driverEmail"
                        v-model="email"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverPassword">Password</label>
                    <input
                        type="password"
                        id="driverPassword"
                        v-model="password"
                        required
                    />
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="CreateDriver"
                        class="submit-btnd"
                    >
                        Submit
                    </button>
                </div>
            </form>
        </div>

        <div v-else class="recent_orders">
            <h1>All Drivers</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!filteredDrivers.length > 0"
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
                                    <th>Status</th>
                                    <th>Select Driver To Bus</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(user, index) in filteredDrivers"
                                    :key="index"
                                >
                                    <td>{{ user.driver_id }}</td>
                                    <td>{{ user.name }}</td>
                                    <td>{{ user.email_driver }}</td>
                                    <td>{{ user.status }}</td>
                                    <td>
                                        <select
                                            :value="user.selectedBusId || ''"
                                            @change="
                                                SelectDriver(
                                                    $event,
                                                    user.driver_id
                                                )
                                            "
                                        >
                                            <option value="">
                                                Select a bus
                                            </option>
                                            <option
                                                v-for="(bus, index) in Bus"
                                                :key="index"
                                                :value="bus.id"
                                            >
                                                {{ bus.number_bus }}
                                            </option>
                                        </select>
                                    </td>
                                    <td>
                                        <button
                                            class="delete-btn"
                                            @click="
                                                showDeleteConfirmation(
                                                    user.driver_id
                                                )
                                            "
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>

                                        <button
                                            class="cancel-btn"
                                            @click="
                                                CancelDriver(user.driver_id)
                                            "
                                        >
                                            <span class="material-icons"
                                                >close_small</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="showDriverStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Driver Status</div>
                <div class="modal-body">
                    <button
                        class="status-btn"
                        @click="fetchDriverStatus('pending')"
                    >
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchDriverStatus('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchDriverStatus('Completed')"
                    >
                        Completed
                    </button>
                    <div v-if="loading1" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!driverStatusData" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            driver, index
                                        ) in driverStatusData"
                                        :key="index"
                                    >
                                        <td>{{ driver.driver_id }}</td>
                                        <td>{{ driver.name }}</td>
                                        <td>{{ driver.email_driver }}</td>
                                        <td>{{ driver.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeDriverStatusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <div v-if="showDriverWithBusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All Drivers with Bus</div>
                <div class="modal-body">
                    <div v-if="loading2" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!driverWithBusData" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Bus ID</th>
                                        <th>Company Name</th>
                                        <th>Bus Plate Number</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            driver, index
                                        ) in driverWithBusData"
                                        :key="index"
                                    >
                                        <td>{{ driver.id }}</td>
                                        <td>{{ driver.driver_name }}</td>
                                        <td>{{ driver.bus_id }}</td>
                                        <td>{{ driver.company_name }}</td>
                                        <td>{{ driver.bus_plate_number }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button
                        @click="closeDriverWithBusModal"
                        class="close-modal"
                    >
                        Close
                    </button>
                </div>
            </div>
        </div>
        <!-- Delete Confirmation Modal -->
        <div v-if="showDeleteConfirmModal" class="dialog-container">
            <div class="dialog-box">
                <div class="dialog-header">Confirm Delete</div>
                <div class="dialog-body">
                    Are you sure you want to delete driver with ID
                    {{ driverIdToDelete }}?
                </div>
                <div class="dialog-footer">
                    <button @click="confirmDeleteDriver" class="confirm-btn">
                        Yes
                    </button>
                    <button
                        @click="closeDeleteConfirmModal"
                        class="close-modal"
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

export default {
    name: "AddDriver",
    data() {
        return {
            loading: true,
            loading1: false,
            loading2: true,

            showForm: true,
            Driver: [],
            Bus: [],
            driverStatusData: [],
            driverWithBusData: [],
            name: "",
            email: "",
            password: "",
            showDriverStatusModal: false,
            showDriverWithBusModal: false,
            toast: useToast(),
            isDarkMode: false,
            showDeleteConfirmModal: false,
            driverIdToDelete: null,
        };
    },
    mounted() {
        this.AllDriver();
        this.fetchBus();
        this.isDarkMode = localStorage.getItem("theme") === "dark";
        if (this.isDarkMode) {
            document.body.classList.add("dark-theme-variables");
        }
    },
    methods: {
        closeDriverStatusModal() {
            this.showDriverStatusModal = false;
        },
        closeDriverWithBusModal() {
            this.showDriverWithBusModal = false;
        },
        handleSubmit() {
            console.log("Form Submitted", this.name, this.email, this.password);
        },
        showDeleteConfirmation(driverId) {
            this.driverIdToDelete = driverId;
            this.showDeleteConfirmModal = true;
        },
        confirmDeleteDriver() {
            this.DeleteDriver(this.driverIdToDelete);
            this.showDeleteConfirmModal = false;
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
        },

        CreateDriver() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/register/driver",
                data: {
                    name: this.name,
                    email: this.email,
                    password: this.password,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status == 200) {
                        console.log(response);
                        this.toast.success(
                            "Driver account created successfully!"
                        );
                        this.AllDriver();
                    }
                })
                .catch((error) => {
                    this.toast.error("Email is already registered.");
                    console.log(error);
                });
        },
        CancelDriver(driverId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/cancelled_driver/${driverId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Driver cancelled successfully!");
                    this.AllDriver();
                })
                .catch((error) => {
                    this.toast.error("Error cancelling driver.");
                    console.error(error);
                });
        },
        AllDriver() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Driver = response.data;
                    store.state.Driver = response.data;
                    console.log(response.data);
                    this.loading = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting drivers.");
                    console.error(error);
                });
            this.loading = true;
        },

        DeleteDriver(driverId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_driver/${driverId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Driver deleted successfully!");
                    this.AllDriver();
                })
                .catch((error) => {
                    this.toast.error("Error deleting driver.");
                    console.error(error);
                });
        },
        fetchBus() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Bus = response.data;
                    console.log(this.Bus);
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
        },
        SelectDriver(event, userId) {
            const busId = event.target.value;
            const access_token = window.localStorage.getItem("access_token");
            console.log("Selected Bus ID:", busId);

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/select_driver_to_bus/${busId}`,
                data: { driver_id: userId },
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    console.log("Selection Complete for Bus ID:", busId);
                    this.toast.success("Driver assigned to bus successfully!");

                    localStorage.setItem(`driver_${userId}_busId`, busId);
                })
                .catch((error) => {
                    this.toast.error("Error assigning driver to bus.");
                    console.error("Error for Bus ID:", busId, error);
                });
        },

        fetchDriverStatus(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/get_driver_by_status?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverStatusData = response.data;
                    console.log(response.data);
                    this.loading1 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading1 = true;
        },
        fetchAllDriverWithBus() {
            this.showDriverWithBusModal = true;

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver_with_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverWithBusData = response.data;
                    console.log(this.driverWithBusData);
                    this.loading2 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching drivers with bus.");
                    console.error(error);
                });
            this.loading2 = true;
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
        filteredDrivers() {
            return store.state.Driver.filter((driver) => {
                return (
                    driver.name
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.email_driver
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.status
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase())
                );
            });
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

    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
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
    border: 0;
    list-style: none;
    appearance: none;
}

body {
    font-family: "Poppins", sans-serif;
    width: 100%;
    height: 100%;
    font-size: 0.88rem;
    user-select: none;
    background: var(--clr-color-background);
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
.dialog-container {
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

.dialog-box {
    background: #fff;
    padding: 20px;
    border-radius: 10px;
    max-width: 500px;
    width: 50%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.dialog-header,
.dialog-body,
.dialog-footer {
    margin-bottom: 10px;
}

.dialog-header {
    font-size: 1.3rem;
    font-weight: bold;
    display: flex;
    justify-content: center;
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
}

.confirm-btn {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 5px;
}

.confirm-btn:hover {
    background-color: #4cae4c;
}

.cancel-btn {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-left: 10px;
}

.cancel-btn:hover {
    background-color: #c9302c;
}
.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 5px;
}
.recent_orders h1 {
    margin: 18px;
    color: var(--clr-dark);
}

.recent_orders {
    width: 100%;
    margin-top: 20px;
}

.table-container {
    width: 100%;
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

table thead tr th {
    padding: 10px;
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

.recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
    font-size: 0.85rem;
}

/* Select styling */
select {
    padding: 8px;
    border: 1px solid var(--clr-primary);
    border-radius: 4px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    font-size: 0.85rem;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: var(--clr-primary);
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}

/* Delete button styling */

.delete-btn.material-icons,
.cancel-btn.material-icons {
    padding: 0;
    border: none;
    margin: 5px;
    border-radius: 50%;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 20px;
    width: 20px;
}

.cancel-btn {
    color: #4caf50;
    background-color: #f1f1f1;
    border-radius: 9px;
    width: 29px;
    padding: 2px;
    margin: 5px;
}
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
.cancel-btn:hover {
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
    background-color: var(--clr-white);
    border-radius: 10px;
    width: 100%;
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

/* Form styling */
.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 20px;
    background-color: var(--clr-info-light);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    max-width: 400px;
    width: 100%;
    margin-top: 50px;
    transition: background-color 0.3s ease;
}
.dark-theme-variables .form-containerd {
    background-color: var(--clr-dark-variant);
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
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
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
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.close-modal:hover {
    background-color: #c9302c;
}

.status-btn {
    padding: 8px 16px;
    margin: 5px;
    border-radius: 4px;
    cursor: pointer;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    transition: background-color 0.3s;
}

.status-btn:hover {
    background-color: var(--clr-primary-variant);
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .container {
        width: 100%;
    }

    .recent_orders {
        padding: 30px;
        margin: 0 auto;
    }

    .right .profile {
        position: absolute;
        left: 70%;
    }

    .right .recent_updates {
        padding: 30px;
    }

    .right .top button {
        display: inline-block;
        background: transparent;
        cursor: pointer;
        color: #363949;
        position: absolute;
        left: 1rem;
    }

    .theme-toggler {
        display: flex;
        justify-content: space-between;
        height: 1.6rem;
        width: 4.2rem;
        cursor: pointer;
        border-radius: 10px;
    }

    .theme-toggler span {
        font-size: 1.2rem;
        width: 50%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .theme-toggler span.active {
        background-color: var(--clr-primary);
        color: var(--clr-white);
        border-radius: 10px;
    }
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
@media screen and (max-width: 480px) {
    .navd {
        align-items: center;
    }

    .nav-btnd {
        padding: 8px 10px;
        font-size: 12px;
    }

    .form-containerd {
        width: 100%;
        padding: 10px;
    }

    .recent_orders h1 {
        font-size: 1rem;
        text-align: center;
    }

    .recent_orders table {
        font-size: 0.75rem;
    }

    select {
        padding: 6px;
        font-size: 0.75rem;
    }

    .delete-btn,
    .cancel-btn {
        height: 16px;
        width: 16px;
        font-size: 12px;
    }

    .modal-content {
        width: 90%;
        padding: 15px;
    }

    .modal-header {
        font-size: 1rem;
    }
}
@media screen and (max-width: 360px) {
    .nav-btnd {
        padding: 6px 8px;
        font-size: 10px;
    }

    .recent_orders h1 {
        font-size: 0.9rem;
    }

    .modal-content {
        padding: 10px;
    }

    .modal-body table {
        font-size: 0.7rem;
    }
}
</style>
