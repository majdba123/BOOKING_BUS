<template>
    <div class="containerd">
        <header class="navd">
            <button class="nav-btnd" @click="toggleshowaddbreack">
                Add Break
            </button>
            <button class="nav-btnd" @click="toggleshowbreack">
                Show Break
            </button>
            <button class="nav-btnd" @click="toggleshowbreackbypath">
                Show Break By Path
            </button>
        </header>
        <div class="content">
            <div class="form-map-container" v-if="showaddbreack">
                <div class="form-container">
                    <form
                        @submit.prevent="handleSubmit(Idgovernment)"
                        class="break-form"
                    >
                        <div class="form-group">
                            <label for="breakName">Name Break</label>
                            <input
                                type="text"
                                id="breakName"
                                placeholder="Enter Name Break"
                                v-model="name"
                                required
                            />
                        </div>
                        <div class="form-group">
                            <label for="government">
                                <span class="material-icons"
                                    >location_city</span
                                >
                                Select Path
                            </label>
                            <select
                                id="government"
                                v-model="Idgovernment"
                                @change="updateMapLocation"
                                required
                                class="custom-select"
                            >
                                <option value="" disabled>Select Path</option>
                                <option
                                    v-for="gov in governments"
                                    :key="gov.id"
                                    :value="gov.id"
                                >
                                    {{ gov.from }}>>{{ gov.to }}
                                </option>
                            </select>
                        </div>

                        <div class="submit-btn">
                            <button type="submit">ADD</button>
                        </div>
                    </form>
                </div>
                <div class="map-container">
                    <MapBreack
                        :lat="this.lat"
                        :long="this.long"
                        :fromlat="frommapLat"
                        :fromlng="frommapLng"
                        :tolng="tomapLng"
                        :tolat="tomapLat"
                    />
                </div>
            </div>
            <div v-if="showbreack" class="recent_orders">
                <h1>All Breaks</h1>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Break Name</th>
                                <th>Display IN Map</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(breack, index) in breaks" :key="index">
                                <td>{{ breack.id }}</td>
                                <td>{{ breack.break_name }}</td>
                                <td>
                                    <button
                                        class="nav-btnd"
                                        @click="
                                            openMapModal(
                                                breack.id,
                                                breack.Path_id
                                            )
                                        "
                                    >
                                        Display
                                    </button>
                                </td>
                                <td>
                                    <button
                                        class="edit-btn"
                                        @click="
                                            openEditModal(
                                                breack.id,
                                                breack.Path_id
                                            )
                                        "
                                    >
                                        <span class="material-icons">edit</span>
                                    </button>
                                    <button
                                        class="delete-btn"
                                        @click="confirmDelete(breack.id)"
                                    >
                                        <span class="material-icons"
                                            >delete</span
                                        >
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div v-if="showbreackbypath" class="recent_orders">
                <h1>Break By Path</h1>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Distance</th>
                                <th>View Break</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(breack, index) in governments"
                                :key="index"
                            >
                                <td>{{ breack.id }}</td>
                                <td>{{ breack.from }}</td>
                                <td>{{ breack.to }}</td>
                                <td>{{ breack.Distance }}</td>
                                <td>
                                    <button
                                        class="nav-btnd"
                                        @click="openbreackmodel(breack.id)"
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
        <div v-if="showbreachpath" class="modal">
            <div class="modal-content">
                <div class="modal-header">Break</div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(bus, index) in breakbypath" :key="index">
                            <td>{{ bus.id }}</td>
                            <td>{{ bus.name }}</td>
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
        <div v-if="showEditModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Break</div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editBreakName">Name Break</label>
                        <input
                            type="text"
                            id="editBreakName"
                            v-model="name"
                            required
                        />
                    </div>

                    <div class="map-container">
                        <MapBreack
                            :fromlat="frommapLatt"
                            :fromlng="frommapLngt"
                            :tolng="tomapLngt"
                            :tolat="tomapLatt"
                            :lat="this.lat"
                            :long="this.long"
                        />
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="updateBreak" class="close-modal">
                        Update
                    </button>
                    <button @click="closeEditModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showMapModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Location on Map</div>
                <div class="modal-body">
                    <div class="map-containers">
                        <DisplayMap
                            :fromlat="this.frommapLat"
                            :fromlong="this.frommapLog"
                            :tolat="this.tomapLat"
                            :tolong="this.tomapLog"
                            :lat="this.lat"
                            :lng="this.long"
                        />
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeMapModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div v-if="showConfirmDeleteModal" class="dialog-container">
            <div class="dialog-box">
                <div class="dialog-header">Confirm Delete</div>
                <div class="dialog-body">
                    Are you sure you want to delete driver with ID
                    {{ breakIdToDelete }}?
                </div>
                <div class="dialog-footer">
                    <button @click="deleteBreak" class="confirm-btn">
                        Yes
                    </button>
                    <button
                        @click="closeConfirmDeleteModal"
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
import MapBreack from "./MapBreack.vue";
import store from "@/store";
import DisplayMap from "./DisplayMap.vue";
import { useToast } from "vue-toastification";

export default {
    name: "AddBreak",
    components: { MapBreack, DisplayMap },
    data() {
        return {
            lat: null,
            long: null,
            breakbypath: [],
            showbreackbypath: false,
            showaddbreack: true,
            showbreack: false,
            showMapModal: false,
            showEditModal: false,
            showbreackpath: false,
            showConfirmDeleteModal: false,
            areaid: "",
            breakIdToDelete: null,
            showbreachpath: false,
            name: "",
            pathid: "",
            frommapLat: 30.033333, // Default latitude for Cairo, Egypt
            frommapLng: 31.233334,
            tomapLat: 30.033333, // Default latitude for Cairo, Egypt
            tomapLng: 31.233334, // Default longitude for Cairo, Egypt
            frommapLatt: 30.033333, // Default latitude for Cairo, Egypt
            frommapLngt: 31.233334,
            tomapLatt: 30.033333, // Default latitude for Cairo, Egypt
            tomapLngt: 31.233334, // Default longitude for Cairo, Egypt
            Idgovernment: "",
            name_break: "",
            showForm: 1,
            break: {
                name: "",
                government: "",
                description: "",
            },
            editedBreak: {
                name: "",
                government: "",
                description: "",
            },
            governments: [],
            breaks: [],
            editingIndex: null,
        };
    },
    setup() {
        const toast = useToast();
        return { toast };
    },
    methods: {
        toggleshowbreackbypath() {
            this.showbreackbypath = true;
            this.showaddbreack = false;
            this.showbreack = false;
        },
        toggleshowaddbreack() {
            this.showbreackbypath = false;
            this.showaddbreack = true;
            this.showbreack = false;
        },
        toggleshowbreack() {
            this.showbreackbypath = false;
            this.showaddbreack = false;
            this.showbreack = true;
        },
        confirmDelete(id) {
            this.breakIdToDelete = id;
            this.showConfirmDeleteModal = true;
        },
        deleteBreak() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_breaks/${this.breakIdToDelete}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Deleted Complete");
                    this.fetchBreaks();
                    this.closeConfirmDeleteModal();
                })
                .catch((error) => {
                    this.toast.error("Error deleting Break");
                    console.error(error);
                });
        },
        closeConfirmDeleteModal() {
            this.showConfirmDeleteModal = false;
            this.breakIdToDelete = null;
        },
        openMapModal(id, path) {
            this.areaid = id;
            this.pathid = path;
            const government = this.governments.find(
                (breack) => breack.id === path
            );
            console.log(this.governments);
            if (government) {
                this.frommapLat = government.from_latitude;
                this.frommapLog = government.from_longitude;
                this.tomapLat = government.to_latitude;
                this.tomapLog = government.to_longitude;
                this.showMapModal = true;
                console.log(
                    this.tomapLog,
                    this.frommapLat,
                    this.frommapLog,
                    this.tomapLat
                );
            }
            const breaks = this.breaks.find((breack) => breack.id === id);
            if (breaks) {
                this.lat = breaks.latitude;
                this.long = breaks.longitude;
                console.log(this.long, this.lat);
            }
        },
        closeMapModal() {
            this.showMapModal = false;
        },

        fetchGovernment() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_path",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.governments = response.data;
                    console.log(this.governments);
                })
                .catch((error) => {
                    this.toast.error("Error getting Path");
                    console.error(error);
                });
        },
        fetchBreaks() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_breaks",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breaks = response.data;
                    console.log(this.breaks);
                })
                .catch((error) => {
                    this.toast.error("Error getting Breaks");
                    console.error(error);
                });
        },
        handleSubmit() {
            console.log(store.state.breacklat, store.state.breacklong);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url:
                    "http://127.0.0.1:8000/api/company/store_breaks/" +
                    this.Idgovernment,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    name: this.name,
                    lat: store.state.selectedLat,
                    long: store.state.selectedLng,
                },
            })
                .then(() => {
                    this.toast.success("Added Complete");
                    this.fetchBreaks();
                    this.resetForm();
                })
                .catch((error) => {
                    console.log(
                        store.state.selectedLat,
                        store.state.selectedLng
                    );
                    this.toast.error("Error adding Break");
                    console.error(error);
                });
        },
        openEditModal(id, path) {
            this.showEditModal = true;
            this.areaid = id;
            this.pathid = path;
            this.fetchBreaks();
            this.updateMapLocation();
            this.updateMapbreackLocation();
        },
        openbreackmodel(id) {
            this.showbreachpath = true;
            this.fetchBreaksbypath(id);
        },
        fetchBreaksbypath(id) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_breaks/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breakbypath = response.data;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        updateBreak() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/update_breaks/${this.areaid}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    name: this.name,
                    pathid: this.Idgovernment,
                },
            })
                .then(() => {
                    this.toast.success("Updated Complete");
                    this.fetchBreaks();
                    this.closeEditModal();
                })
                .catch((error) => {
                    this.toast.error("Error updating Break");
                    console.error(error);
                });
        },
        closeEditModal() {
            this.showEditModal = false;
        },
        updateMapbreackLocation() {
            const selectedbreack = this.breaks.find(
                (gov) => gov.id === this.areaid
            );

            if (selectedbreack) {
                this.lat = selectedbreack.latitude;
                this.long = selectedbreack.longitude;

                console.log(`Latitude: ${this.lat}, Longitude: ${this.long}`);
            } else {
                console.error(`ID: ${this.areaid} not found in breaks`);
            }
        },

        updateMapLocation() {
            const selectedGovernment = this.governments.find(
                (gov) => gov.id === this.Idgovernment
            );
            if (selectedGovernment) {
                this.frommapLat = selectedGovernment.from_latitude;
                this.frommapLng = selectedGovernment.from_longitude;
                this.tomapLat = selectedGovernment.to_latitude;
                this.tomapLng = selectedGovernment.to_longitude;
                console.log(
                    this.tomapLng,
                    this.tomapLat,
                    this.frommapLng,
                    this.frommapLat
                );
            }
            const selectedGovernmet = this.governments.find(
                (gov) => gov.id === this.pathid
            );
            if (selectedGovernmet) {
                this.frommapLatt = selectedGovernmet.from_latitude;
                this.frommapLngt = selectedGovernmet.from_longitude;
                this.tomapLatt = selectedGovernmet.to_latitude;
                this.tomapLngt = selectedGovernmet.to_longitude;
                console.log(
                    this.tomapLngt,
                    this.tomapLatt,
                    this.frommapLngt,
                    this.frommapLatt
                );
            }
        },

        resetForm() {
            this.name = "";
            this.Idgovernment = "";
            this.mapLat = 30.033333;
            this.mapLng = 31.233334;
        },
    },
    mounted() {
        this.fetchGovernment();
        this.fetchBreaks();
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

.containerd {
    padding: 20px;
    background: #f6f6f9;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
}

.header {
    width: 100%;
}

.content {
    width: 100%;
    max-width: 1200px;
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.form-map-container {
    display: flex;
    gap: 10px;
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: var(--box-shadow);
    width: 100%;
}

.form-container {
    display: flex;
    flex-direction: column;
    gap: 15px;
    flex: 1;
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

.break-form {
    display: flex;
    flex-direction: column;
    gap: 15px;
    width: 100%;
}

.form-group {
    display: flex;
    flex-direction: column;
}

label {
    margin: 10px;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    font-weight: 500;
    color: #363949;
}

label .material-icons {
    margin-right: 8px;
}

input,
select,
textarea {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    width: 100%;
    font-size: 1rem;
}

input:focus,
select:focus,
textarea:focus {
    border-color: #007bff;
}

.submit-btn {
    margin: 10px;
    text-align: center;
}

.submit-btn button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.submit-btn button:hover {
    background-color: #0056b3;
}

.map-container {
    flex: 1;
    min-width: 400px;
    height: 400px;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: var(--box-shadow);
    padding: 10px;
    margin-bottom: 30px;
}

/* Custom Select styling */
.custom-select {
    appearance: none;
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    font-size: 1rem;
    transition: border-color 0.3s;
}
.custom-select option {
    color: #007bff;
}
.custom-select:focus {
    border-color: #007bff;
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

.edit-btn.material-icons,
.delete-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 10px;
    border-radius: 3px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 30px;
    width: 30px;
}

.edit-btn {
    color: #4caf50;
    background-color: #f1f1f1;
    border-radius: 9px;
    padding: 3px;
    margin: 10px;
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
/* ***Modal styling */
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
    justify-content: center;
}

.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 10px;
    transition: all 0.1s ease;
}

.close-modal:hover {
    background-color: #c9302c;
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

    .form-map-container {
        flex-direction: column;
    }

    .form-container {
        width: 100%;
    }

    .map-container {
        width: 100%;
        height: 300px;
    }

    .modal-content {
        width: 90%;
    }
}
</style>
