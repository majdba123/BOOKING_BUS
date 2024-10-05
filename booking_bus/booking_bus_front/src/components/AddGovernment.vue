<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnddd" @click="showForm = true">
                Add Government
            </button>
            <button class="nav-btnddd" @click="showForm = false">
                Show Government
            </button>
        </header>

        <div v-if="showForm" class="form-map-container">
            <div class="map-container">
                <GoogleMap />
                <button type="submit" @click="CreateDriver" class="submit-btnd">
                    Submit
                </button>
            </div>
        </div>

        <div v-else class="recent_orders">
            <h1>All Government</h1>
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
                                    <th>Breack</th>
                                    <th>ِActions</th>
                                    <th>Display In Map</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(user, index) in filteredGovernment"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ user.name }}</td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-primary"
                                            @click="openBreackModal(user.id)"
                                        >
                                            Breack
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="delete-btn"
                                            @click="DeleteGovernment(user.id)"
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                        <button
                                            class="edit-btn"
                                            @click="openEditModal(user, id)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-primary"
                                            @click="openMapModal(user.id)"
                                        >
                                            Display
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="showMapModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Location on Map</div>
                <div class="modal-body">
                    <DisplayMap :lat="mapLat" :lng="mapLng" />
                </div>
                <div class="modal-footer">
                    <button @click="closeMapModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <div v-if="showGovernmentBreackModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Breack</div>
                <div class="modal-body">
                    <div v-if="loading1" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!GovernmentBreack.length > 0"
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
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            driver, index
                                        ) in GovernmentBreack"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ driver.name }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button
                        @click="closeGovernmentBreackModal"
                        class="close-modal"
                    >
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showEditModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Government</div>
                <div class="modal-body">
                    <UpdateMapGovernment />
                </div>
                <div class="modal-footer">
                    <button class="update-btn" @click="updateGovernment">
                        Update
                    </button>
                    <button @click="closeEditModal" class="close-modal">
                        Cancel
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
import { Chart } from "chart.js";
import GoogleMap from "./MapGovernment.vue";
import UpdateMapGovernment from "./UpdateMapGovernment.vue";
import DisplayMap from "./DisplayMap.vue";

export default {
    name: "AddDriver",
    data() {
        return {
            loading: true,
            loading1: true,

            showEditModal: false,
            showMapModal: false,
            mapLat: null,
            mapLng: null,
            showForm: true,
            GovernmentBreack: [],
            name: "",
            currentCompanyId: "",
            showGovernmentBreackModal: false,
            toast: useToast(),
            isDarkMode: false, // إدارة حالة الوضع الداكن
            editedGovernment: { name: "" },
        };
    },
    mounted() {
        this.AllGovernment();
        this.isDarkMode = localStorage.getItem("theme") === "dark";
        if (this.isDarkMode) {
            document.body.classList.add("dark-theme-variables");
        }
    },
    methods: {
        openMapModal(id) {
            const government = this.Driver.find((driver) => driver.id === id);
            if (government) {
                this.mapLat = government.latitude;
                this.mapLng = government.longitude;
                this.showMapModal = true;
                // console.log(this.mapLat, this.mapLng);
            }
        },
        closeMapModal() {
            this.showMapModal = false;
        },

        openEditModal(Government, index) {
            this.editedGovernment = { ...Government };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        openBreackModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchGovernmentBreack(this.currentCompanyId);
            this.showGovernmentBreackModal = true;
        },
        closeEditModal() {
            this.showEditModal = false;
        },

        closeGovernmentBreackModal() {
            this.showGovernmentBreackModal = false;
        },
        closeDriverWithBusModal() {
            this.showDriverWithBusModal = false;
        },
        handleSubmit() {
            // console.log("Form Submitted", this.name, this.email, this.password);
        },
        updateGovernment() {
            const access_token = window.localStorage.getItem("access_token");
            const pathId = this.editedGovernment.id;
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/admin/update_government/${pathId}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    name: store.state.placeName,
                    lat: store.state.lat,
                    long: store.state.lng,
                },
            })
                .then(() => {
                    this.editingIndex = null;
                    this.editedGovernment = { name: "" };
                    this.toast.success("Government Updated Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.showEditModal = false;
                    this.AllGovernment();
                })
                .catch(() => {
                    this.toast.error("Error Updating Government", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                });
        },
        CreateDriver() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/admin/store_government",
                data: {
                    name: store.state.placeName,
                    lat: store.state.lat,
                    long: store.state.lng,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status == 200) {
                        this.toast.success("Government created successfully!");
                        this.AllGovernment();
                    }
                })
                .catch((error) => {
                    this.toast.error(error.response.data.error.name[0]);
                });
        },

        AllGovernment() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Driver = response.data;
                    store.state.Government = response.data;
                    this.loading = false;
                })
                .catch(() => {
                    this.toast.error("Error getting government.");
                });
            this.loading = true;
        },
        DeleteGovernment(driverId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/admin/delete_government/${driverId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Government deleted successfully!");
                    this.AllGovernment();
                })
                .catch(() => {
                    this.toast.error("Error deleting Government.");
                });
        },

        fetchGovernmentBreack(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/show_goverment/${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.GovernmentBreack = response.data.breaks;
                    this.loading1 = false;
                })
                .catch(() => {
                    window.alert("Error fetching Break");
                });
            this.loading1 = true;
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
                return driver.name
                    .toLowerCase()
                    .includes(store.state.searchQuery.toLowerCase());
            });
        },
    },
    components: { GoogleMap, UpdateMapGovernment, DisplayMap },
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
.nav-btnd.btn-primary {
    background: #7380ec !important;
}
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px; /* Adjust as needed */
    font-size: 1.2rem;
    color: #677483;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background-color: #f6f6f9;
}
.btn-primary {
    background: linear-gradient(90deg, #7380ec 0%, #4b6cb7 100%) !important;
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
.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh; /* تجعل الـ spinner يأخذ كامل الشاشة */
}

.spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-left-color: #007bff;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}
.recent_orders th,
.recent_orders td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}
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
.recent_orders tbody tr:hover {
    background-color: #f1f1f1;
}
.recent_orders td {
    text-align: center;
}
.recent_orders thead {
    background-color: var(--clr-primary);
    color: #fff;
}
.recent_orders table {
    background-color: #fff;
    width: 100%;
    border-radius: var(--border-radius-2);
    padding: 1rem;
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    font-size: 0.85rem;
    border-collapse: collapse; /* Ensure borders are collapsed */
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
.btn-success {
    background: linear-gradient(90deg, #41f1b6 0%, #28a745 100%) !important;
}
.nav-btnd.btn-success {
    background: #4caf50;
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
.nav-btnddd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
}
.nav-btnddd {
    padding: 10px 20px;
    margin: 0 10px; /* مسافة صغيرة بين الأزرار */
    border: none;
    border-radius: 5px; /* تقليل نصف القطر */
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 14px;
    font-weight: bold;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
    flex-grow: 1;
    text-align: center;
}
.navd {
    display: flex;
    align-items: center;
    justify-content: center;

    background-color: var(--clr-white);
    border-radius: 5px;
    width: 100%;
    padding: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
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
    border-radius: var(--border-radius-2);
    max-width: 90%;
    width: 90%;
    height: auto;
    max-height: 80%;
    box-shadow: var(--box-shadow);
    overflow: auto;
}

.modal-header,
.modal-body div,
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

.modal-body div table {
    width: 100%;
    border-collapse: collapse;
}

.modal-body div th,
.modal-body div td {
    padding: 12px;
    text-align: left;
}

.modal-body div th {
    background-color: var(--clr-primary);
    color: #fff;
}

.modal-body div td {
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

.update-btn {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-right: 10px;
}
@media (max-width: 768px) {
    .modal-content {
        width: 95%;
        height: auto;
    }

    .modal-body div {
        flex-direction: column;
    }

    .profile-image {
        max-width: 80px;
    }
}
.update-btn:hover {
    background-color: #489248;
}
</style>
