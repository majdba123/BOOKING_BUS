<template>
    <div class="containerd">
        <header class="navd">
            <button class="nav-btnd" @click="toggleshowaddbreack">
                Add Break
            </button>

            <button class="nav-btnd" @click="toggleshowbreackbypath">
                Show Break By Path
            </button>
        </header>
        <div class="form-map-container" v-if="showaddbreack">
            <div class="form-containerd">
                <div class="break-form">
                    <div class="form-group">
                        <label for="government"> Select Path </label>
                        <select
                            id="government"
                            v-model="Idgovernment"
                            @change="updateMapLocation(Idgovernment)"
                            required
                            class="custom-select"
                        >
                            <option value="" disabled class="custom-select">
                                Select Path
                            </option>
                            <option
                                v-for="gov in governments"
                                :key="gov.id"
                                :value="gov.id"
                            >
                                {{ gov.from }}>>{{ gov.to }}
                            </option>
                        </select>
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
                    <div class="submit-btn">
                        <button @click="handleSubmit(Idgovernment)">ADD</button>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="showbreackbypath" class="recent_orders">
            <h2>Break By Path</h2>
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
                            v-for="(breack, index) in filteredDrivers"
                            :key="index"
                        >
                            <td>{{ index }}</td>
                            <td>{{ breack.from }}</td>
                            <td>{{ breack.to }}</td>
                            <td>{{ breack.Distance }}</td>
                            <td>
                                <button
                                    class="nav-btnds"
                                    @click="openbreackmodel(breack.id)"
                                >
                                    <span class="material-icons">
                                        travel_explore
                                    </span>
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
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(bus, index) in breakbypath" :key="index">
                        <td>{{ index }}</td>
                        <td>{{ bus.name }}</td>
                        <td>
                            <button
                                class="edit-btn"
                                @click="openEditModal(bus.id, bus.path_id)"
                            >
                                <span class="material-icons">edit</span>
                            </button>
                            <button
                                class="delete-btn"
                                @click="confirmDelete(bus.id)"
                            >
                                <span class="material-icons">delete</span>
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="modal-footer">
                <button @click="closeBusStatusModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
    </div>
    <div v-if="showEditModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Edit Break</div>
            <div class="modal-body">
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
                <button @click="updateBreak" class="update-btn">Update</button>
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
                Are you sure you want to delete breack with ID
                {{ breakIdToDelete }}?
            </div>
            <div class="dialog-footer">
                <button @click="deleteBreak" class="confirm-btn">Yes</button>
                <button @click="closeConfirmDeleteModal" class="close-modal">
                    No
                </button>
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
            frommapLat: 30.033333,
            frommapLng: 31.233334,
            tomapLat: 30.033333,
            tomapLng: 31.233334,
            frommapLatt: 30.033333,
            frommapLngt: 31.233334,
            tomapLatt: 30.033333,
            tomapLngt: 31.233334,
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
        closeBusStatusModal() {
            this.showbreachpath = false;
        },
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
                .catch(() => {
                    this.toast.error("Error deleting Break");
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
            if (government) {
                this.frommapLat = government.from_latitude;
                this.frommapLog = government.from_longitude;
                this.tomapLat = government.to_latitude;
                this.tomapLog = government.to_longitude;
                this.showMapModal = true;
            }
            const breaks = this.breaks.find((breack) => breack.id === id);
            if (breaks) {
                this.lat = breaks.latitude;
                this.long = breaks.longitude;
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
                })
                .catch(() => {
                    this.toast.error("Error getting Path");
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
                })
                .catch(() => {
                    this.toast.error("Error getting Breaks");
                });
        },
        async handleSubmit() {
            const access_token = window.localStorage.getItem("access_token");
            for (
                let index = 0;
                index < store.state.breakpoints.length;
                index++
            ) {
                await axios({
                    method: "post",
                    url:
                        "http://127.0.0.1:8000/api/company/store_breaks/" +
                        this.Idgovernment,
                    headers: { Authorization: `Bearer ${access_token}` },
                    data: {
                        name: store.state.breakpoints[index].name,
                        lat: store.state.breakpoints[index].lat,
                        long: store.state.breakpoints[index].lng,
                    },
                })
                    .then(() => {
                        this.toast.success("Added Complete");
                        this.fetchBreaks();
                    })
                    .catch(() => {
                        this.toast.error("Error Add Break");
                    });
            }
        },
        openEditModal(id, path) {
            this.showEditModal = true;
            this.areaid = id;
            this.pathid = path;
            this.updateMapLocation(path);
            this.updateMapbreackLocation();
        },
        openbreackmodel(id) {
            this.showbreachpath = true;
            this.fetchBreaksbypath(id);
        },
        async fetchBreaksbypath(id) {
            const access_token = window.localStorage.getItem("access_token");
            await axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_breaks/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breakbypath = response.data;
                })
                .catch(() => {});
        },
        updateBreak() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/update_breaks/${this.areaid}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    name: store.state.breakpoints[0].name,
                    lat: store.state.breakpoints[0].lat,
                    long: store.state.breakpoints[0].lng,
                },
            })
                .then(() => {
                    this.toast.success("Updated Complete");
                    this.fetchBreaks();
                    this.closeEditModal();
                })
                .catch(() => {
                    this.toast.error("Error updating Break");
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
            }
        },

        updateMapLocation(path) {
            const selectedGovernment = this.governments.find(
                (gov) => gov.id === path
            );
            if (selectedGovernment) {
                this.frommapLat = selectedGovernment.from_latitude;
                this.frommapLng = selectedGovernment.from_longitude;
                this.tomapLat = selectedGovernment.to_latitude;
                this.tomapLng = selectedGovernment.to_longitude;
            }

            const selectedGovernmet = this.governments.find(
                (gov) => gov.id === path
            );
            if (selectedGovernmet) {
                this.frommapLatt = selectedGovernmet.from_latitude;
                this.frommapLngt = selectedGovernmet.from_longitude;
                this.tomapLatt = selectedGovernmet.to_latitude;
                this.tomapLngt = selectedGovernmet.to_longitude;
            }
        },

        resetForm() {
            this.name = "";
            this.Idgovernment = "";
            this.mapLat = 30.033333;
            this.mapLng = 31.233334;
        },
    },
    computed: {
        filteredDrivers() {
            return this.governments.filter((driver) => {
                return (
                    driver.from
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.to
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase())
                );
            });
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
h2 {
    font-size: 1.2rem;
    color: var(--clr-dark);
    margin-bottom: 5px;
    margin-left: 15px;
    margin-top: 5px;
}

.header {
    width: 100%;
}

.form-map-container {
    display: flex;
    flex-direction: column;
    height: 100vh;
}

.form-containerd {
    padding: 20px;
    background-color: var(--clr-white);
    box-shadow: var(--box-shadow);
    border-radius: var(--border-radius-2);
    margin-top: 20px;
    width: 100% !important;
    margin-bottom: 20px;
}

/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
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
    color: var(--clr-dark);
}

label .material-icons {
    margin-right: 8px;
}

input,
select,
textarea {
    padding: 10px;
    border: 1px solid var(--clr-dark-variant);
    border-radius: var(--border-radius-2);
    transition: border-color 0.3s;
    width: 100%;
    font-size: 1rem;
}

input:focus,
select:focus,
textarea:focus {
    border-color: var(--clr-primary);
}

.submit-btn {
    margin: 10px;
    text-align: center;
}

.submit-btn button {
    width: 100%;
    padding: 10px 20px;
    border: none;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s, transform 0.2s;
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

.submit-btn button:hover {
    background-color: var(--clr-primary-variant);
    transform: translateY(-3px);
}

.map-container {
    flex: 1;
    min-width: 400px;
    height: 400px;
    border-radius: var(--border-radius-3);
    overflow: hidden;
    padding: 10px;
}
.nav-btnds {
    padding: 4px 9px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
}

.nav-btnds:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s ease;
}

/* Custom Select styling */
.custom-select {
    appearance: none;
    background-color: var(--clr-white);
    border: 1px solid var(--clr-dark-variant);
    border-radius: var(--border-radius-2);
    padding: 10px;
    font-size: 1rem;
    transition: border-color 0.3s;
}
.custom-select option {
    color: var(--clr-primary);
}
.custom-select:focus {
    border-color: var(--clr-primary);
}

/* Table styling */
.recent_orders {
    width: 100%;
    overflow-x: auto;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: var(--border-radius-3);
    padding: var(--card-padding);
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
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

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}

table tbody tr:last-child td {
    border: none;
}

.edit-btn.material-icons,
.delete-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 10px;
    border-radius: var(--border-radius-1);
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
    background: var(--clr-white);
    padding: 20px;
    border-radius: var(--border-radius-3);
    max-width: 500px;
    width: 50%;
    box-shadow: var(--box-shadow);
    text-align: center;
    color: var(--clr-dark);
}

.dialog-header,
.dialog-body,
.dialog-footer {
    margin-bottom: 20px;
}

.dialog-header {
    font-size: 1.3rem;
    font-weight: bold;
    text-align: center;
}

.dialog-body {
    text-align: center;
}

.dialog-footer {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.confirm-btn {
    padding: 8px 16px;
    background-color: var(--clr-success);
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-2);
    cursor: pointer;
}

.confirm-btn:hover {
    background-color: var(--clr-success);
}

.cancel-btn {
    padding: 8px 16px;
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-2);
    cursor: pointer;
}

.cancel-btn:hover {
    background-color: var(--clr-danger);
}

.close-modal {
    padding: 8px 16px;
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-2);
    cursor: pointer;
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
    background-color: var(--clr-white);
    color: var(--clr-dark);
    padding: 20px;
    border-radius: 10px;
    max-width: 600px;
    width: 90%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    overflow-y: auto;
    max-height: 90vh;
}

.modal-content::-webkit-scrollbar {
    display: none;
}

.modal-content {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
.modal table {
    width: 100%;
}
.modal table th,
.modal table td {
    text-align: center;
    vertical-align: middle;
    padding: 10px;
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
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-1);
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
    border-radius: var(--border-radius-1);
    cursor: pointer;
    margin-right: 10px;
}

.update-btn:hover {
    background-color: #489248;
}
/* Responsive Design */
@media screen and (max-width: 768px) {
    .containerd {
        padding: 10px;
    }

    .navd {
        align-items: center;
    }

    .nav-btnd {
        padding: 6px 8px;
        font-size: 10px;
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
