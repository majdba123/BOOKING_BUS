<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <div class="recent_orders">
            <h1>All Users</h1>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Point</th>
                            <th>Email Verified At</th>
                            <th>Created At</th>
                            <th>Updated At</th>
                            <th>Profile</th>
                            <th>All Reservation</th>
                            <th>All Trip History</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(user, index) in Users" :key="index">
                            <td>{{ user.id }}</td>
                            <td>{{ user.name }}</td>
                            <td>{{ user.email }}</td>
                            <td>{{ user.point }}</td>
                            <td>{{ user.email_verified_at }}</td>
                            <td>{{ user.created_at }}</td>
                            <td>{{ user.updated_at }}</td>
                            <td>
                                <button
                                    class="nav-btnd"
                                    @click="openBreackModal(user.id)"
                                >
                                    View
                                </button>
                            </td>
                            <td>
                                <button
                                    class="nav-btnd"
                                    @click="openReservationModal(user.id)"
                                >
                                    View
                                </button>
                            </td>
                            <td>
                                <button
                                    class="nav-btnd"
                                    @click="openTripModal(user.id)"
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
    <div v-if="showGovernmentBreackModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Profile</div>
            <div class="modal-body">
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
                            <td>{{ Profile.profile?.image }}</td>
                        </tr>
                    </tbody>
                </table>
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
                <table>
                    <thead>
                        <tr>
                            <th>area_name</th>
                            <th>break_name</th>
                            <th>reservation_status</th>
                            <th>reservation_type</th>
                            <th>Seat</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(driver, index) in Reservation" :key="index">
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
                        <tr v-for="(driver, index) in Trip" :key="index">
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
            <div class="modal-footer">
                <button @click="closeTripModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showSeatModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">All Seat</div>
            <div class="modal-body">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(driver, index) in Seat" :key="index">
                            <td>{{ driver.seat_id }}</td>
                            <td>{{ driver.status }}</td>
                        </tr>
                    </tbody>
                </table>
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
import axios from "axios";
import store from "@/store";
import { useToast } from "vue-toastification";
import { Chart } from "chart.js";

export default {
    name: "AddDriver",
    data() {
        return {
            Trip: [],
            showSeatModal: false,
            Seat: [],
            showReservationModal: false,
            showTripModal: false,

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
        this.$nextTick(() => {
            this.createChart(); // إنشاء الرسم البياني بعد التأكد من جاهزية DOM
            // تحديث السائقين بالقيم المخزنة في localStorage
            this.Driver.forEach((driver) => {
                const savedBusId = localStorage.getItem(
                    `driver_${driver.driver_id}_busId`
                );
                if (savedBusId) {
                    driver.selectedBusId = savedBusId;
                }
            });
        });
    },
    methods: {
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
        openSeat(x) {
            // Set the current company ID
            this.fetchReservationSeat(x, this.currentCompanyId);
            this.showSeatModal = true;
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
                    store.state.Users = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    this.toast.error("Error getting drivers.");
                    console.error(error);
                });
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
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching Profile");
                    console.error(error);
                });
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

                    console.log(this.Seat);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
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

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
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

                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
        },

        toggleTheme() {
            this.isDarkMode = !this.isDarkMode;
            document.body.classList.toggle(
                "dark-theme-variables",
                this.isDarkMode
            );
            localStorage.setItem("theme", this.isDarkMode ? "dark" : "light");
        },
        createChart() {
            // هنا يمكنك إنشاء الرسم البياني الخاص بك باستخدام Chart.js
            const ctx = document.getElementById("myChart").getContext("2d");
            new Chart(ctx, {
                type: "bar",
                data: {
                    labels: [
                        "Red",
                        "Blue",
                        "Yellow",
                        "Green",
                        "Purple",
                        "Orange",
                    ],
                    datasets: [
                        {
                            label: "# of Votes",
                            data: [12, 19, 3, 5, 2, 3],
                            backgroundColor: [
                                "rgba(255, 99, 132, 0.2)",
                                "rgba(54, 162, 235, 0.2)",
                                "rgba(255, 206, 86, 0.2)",
                                "rgba(75, 192, 192, 0.2)",
                                "rgba(153, 102, 255, 0.2)",
                                "rgba(255, 159, 64, 0.2)",
                            ],
                            borderColor: [
                                "rgba(255, 99, 132, 1)",
                                "rgba(54, 162, 235, 1)",
                                "rgba(255, 206, 86, 1)",
                                "rgba(75, 192, 192, 1)",
                                "rgba(153, 102, 255, 1)",
                                "rgba(255, 159, 64, 1)",
                            ],
                            borderWidth: 1,
                        },
                    ],
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                        },
                    },
                },
            });
        },
    },
    computed: {
        filteredGovernment() {
            return store.state.Government.filter((driver) => {
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
    components: {},
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
    width: 50%;
    height: 85%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    overflow: scroll;
}

.modal-header,
.modal-body,
.modal-footer {
    margin-bottom: 10px;
}

.modal-header {
    font-size: 1.3rem;
    font-weight: bold;
    display: flex;
    justify-content: center;
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
    background-color: #489248;
}
</style>
