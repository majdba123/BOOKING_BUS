<template>
    <div class="containerd">
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
            <button class="nav-btnd" @click="showDriverWithBusModal = true">
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
                                    @change="
                                        SelectDriver($event, user.driver_id)
                                    "
                                >
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
                                    @click="DeleteDriver(user.driver_id)"
                                >
                                    Delete
                                </button>
                                <button
                                    class="cancel-btn"
                                    @click="CancelDriver(user.driver_id)"
                                >
                                    Cancel
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
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
                        @click="fetchDriverStatus('completed')"
                    >
                        Completed
                    </button>
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
                                v-for="(driver, index) in driverStatusData"
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
                                v-for="(driver, index) in driverWithBusData"
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
        };
    },
    mounted() {
        this.AllDriver();
        this.fetchBus();
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
                })
                .catch((error) => {
                    this.toast.error("Error getting drivers.");
                    console.error(error);
                });
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
                    this.AllDriver();
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
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
        },
        fetchAllDriverWithBus() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver_with_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverWithBusData = response.data;
                    console.log(this.driverWithBusData);
                    this.showDriverWithBusModal = true;
                })
                .catch((error) => {
                    window.alert("Error fetching drivers with bus.");
                    console.error(error);
                });
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
    background: #f6f6f9;
}

.recent_orders h1 {
    margin: 18px;
    color: #363949;
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

.recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
    font-size: 0.85rem;
}

/* Select styling */
select {
    padding: 8px;
    border: 1px solid #7380ec;
    border-radius: 4px;
    background-color: #fff;
    color: #363949;
    font-size: 0.85rem;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: #007bff;
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}

/* Delete button styling */
.delete-btn,
.cancel-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s;
    border: 1px solid #ff7782;
    background-color: #fff;
    color: #ff7782;
}

.delete-btn:hover,
.cancel-btn:hover {
    background-color: #ff7782;
    color: #fff;
    transform: translateY(-3px);
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
    margin: 0 auto;
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

/* Form styling */
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
    background-color: #d9534f;
    color: white;
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
    background-color: #007bff;
    color: white;
    transition: background-color 0.3s;
}

.status-btn:hover {
    background-color: #0056b3;
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
        background-color: #7380ec;
        color: #fff;
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
}
</style>
