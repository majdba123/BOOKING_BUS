<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">Add Path</button>
            <button class="nav-btnd" @click="showForm = false">
                Show Path
            </button>
        </header>

        <div v-if="showForm" class="form-map-container">
            <form @submit.prevent="handleSubmit" class="form-containerd">
                <h2>Add Path</h2>
                <div class="form-groupd">
                    <label for="nameStart">Name Start</label>
                    <input
                        type="text"
                        id="nameStart"
                        v-model="StartPath"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="nameEnd">Name End</label>
                    <input
                        type="text"
                        id="nameEnd"
                        v-model="EndPath"
                        required
                    />
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="CreatePath"
                        class="submit-btnd"
                    >
                        Submit
                    </button>
                </div>
            </form>
            <div class="map-container">
                <MapPath />
            </div>
        </div>

        <div v-else class="recent_orders">
            <h1>All Paths</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!filteredPaths.length > 0"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name Start</th>
                                    <th>Name End</th>
                                    <th>Distance</th>
                                    <th>Display In Map</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(path, index) in filteredPaths"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ path.from }}</td>
                                    <td>{{ path.to }}</td>
                                    <td>{{ path.Distance }}</td>
                                    <td>
                                        <button
                                            class="nav-btnds"
                                            @click="openMapModal(path.id)"
                                        >
                                            <span class="material-icons">
                                                travel_explore
                                            </span>
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="edit-btn"
                                            @click="openEditModal(path, index)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                        <button
                                            class="delete-btn"
                                            @click="
                                                openDeleteConfirmModal(path)
                                            "
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
            </div>
        </div>

        <div v-if="showEditModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Path</div>
                <div class="modal-body">
                    <label for="editNameStart">Name Start</label>
                    <input
                        type="text"
                        id="editNameStart"
                        v-model="editedPath.from"
                        required
                    />

                    <label for="editNameEnd">Name End</label>
                    <input
                        type="text"
                        id="editNameEnd"
                        v-model="editedPath.to"
                        required
                    />

                    <div class="map-containers">
                        <MapPath />
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="update-btn" @click="updatePath">
                        Update
                    </button>
                    <button @click="closeEditModal" class="close-modal">
                        Cancel
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
        <div v-if="showDeleteConfirmModal" class="dialog-container">
            <div class="dialog-box">
                <div class="dialog-header">Confirm Delete</div>
                <div class="dialog-body">
                    Are you sure you want to delete path from
                    {{ pathToDelete.from }} to {{ pathToDelete.to }}?
                </div>
                <div class="dialog-footer">
                    <button @click="deleteConfirmedPath" class="confirm-btn">
                        Yes
                    </button>
                    <button @click="closeDeleteConfirmModal" class="cancel-btn">
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
import MapPath from "./MapPath.vue";
import { useToast } from "vue-toastification";
import DisplayMap from "./DisplayMap.vue";

export default {
    name: "AddPath",
    components: { MapPath, DisplayMap },
    data() {
        return {
            frommapLat: null,
            frommapLog: null,
            tomapLat: null,
            tomapLog: null,
            showMapModal: false,
            loading: true,
            id: "",
            showForm: true,
            Paths: [],
            StartPath: "",
            EndPath: "",
            showEditModal: false,
            editedPath: { from: "", to: "" },
            editingIndex: null,
            toast: useToast(),
            showDeleteConfirmModal: false,
            pathToDelete: {},
        };
    },
    mounted() {
        this.AllPaths();
    },
    methods: {
        closeMapModal() {
            this.showMapModal = false;
        },
        openMapModal(id) {
            this.id = id;
            const government = this.Paths.find((breack) => breack.id === id);
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
        },
        handleSubmit() {
            console.log("Form Submitted", this.StartPath, this.EndPath);
        },
        CreatePath() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/path_store",
                data: {
                    from: this.StartPath,
                    to: this.EndPath,
                    lat_from: store.state.startLat,
                    long_from: store.state.startLng,
                    lat_to: store.state.endLat,
                    long_to: store.state.endLng,
                    Distance: store.state.distance,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status === 200) {
                        console.log(response);
                        this.toast.success("Path Created Successfully", {
                            transition: "Vue-Toastification__bounce",
                            hideProgressBar: true,
                            closeOnClick: true,
                            pauseOnFocusLoss: false,
                            pauseOnHover: true,
                            draggable: true,
                            draggablePercent: 0.6,
                        });
                        this.AllPaths();
                    }
                })
                .catch((error) => {
                    this.toast.error("Error Creating Path", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.log(error);
                });
        },
        AllPaths() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_path",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Paths = response.data;
                    store.state.Paths = response.data;
                    console.log(response.data);
                    this.loading = false;
                })
                .catch((error) => {
                    this.toast.error("Error Getting Paths", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.error(error);
                });
            this.loading = true;
        },
        openDeleteConfirmModal(path) {
            this.pathToDelete = path;
            this.showDeleteConfirmModal = true;
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
        },
        deleteConfirmedPath() {
            const id = this.pathToDelete.id;
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/path_delete/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.Paths = this.Paths.filter(
                        (pathItem) => pathItem.id !== id
                    );
                    this.toast.success("Path Deleted Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.AllPaths();
                })
                .catch((error) => {
                    this.toast.error("Error Deleting Path", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.error(error);
                })
                .finally(() => {
                    this.closeDeleteConfirmModal();
                });
        },
        openEditModal(path, index) {
            this.editedPath = { ...path };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        closeEditModal() {
            this.showEditModal = false;
        },
        updatePath() {
            const id = this.editedPath.id;
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/path_update/${id}`,
                data: {
                    from: this.editedPath.from,
                    to: this.editedPath.to,
                    lat_from: store.state.startLat,
                    long_from: store.state.startLng,
                    lat_to: store.state.endLat,
                    long_to: store.state.endLng,
                    Distance: store.state.distance,
                },
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.Paths[this.editingIndex] = { ...this.editedPath };
                    this.toast.success("Path Updated Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.AllPaths();
                })
                .catch((error) => {
                    this.toast.error("Error Updating Path", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.error(error);
                })
                .finally(() => {
                    this.closeEditModal();
                });
        },
    },
    computed: {
        filteredPaths() {
            return this.Paths;
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
    --border-radius-3: 0.9rem;
    --padding-1: 1.2rem;
    --box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

/* Dark theme variables */
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
    overflow-x: auto;
    margin-top: 20px;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders table {
    width: 100%;
    border-radius: var(--border-radius-1);
    padding: var(--padding-1);
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
    background-color: var(--clr-white);
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
    color: var(--clr-primary);
}

/* No data message */
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

/* Select styling */
select {
    padding: 8px;
    border: 1px solid var(--clr-primary);
    border-radius: 4px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
}

select:focus {
    border-color: var(--clr-primary-variant);
}

/* Button styling */
.edit-btns {
    color: var(--clr-white);
    background-color: var(--clr-success);
    border-radius: var(--border-radius-2);
    padding: 10px;
    margin: 5px;
    transition: background-color 0.3s;
}

.edit-btns:hover {
    background-color: var(--clr-dark-variant);
}

/* Spinner */
.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh;
}

.spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}

/* Button styles with icons */
.edit-btn.material-icons,
.delete-btn.material-icons,
.status-btn.material-icons {
    padding: 2px 6px;
    border: none;
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
    border-radius: var(--border-radius-2);
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
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

.nav-btnds {
    padding: 4px 9px;
    border: none;
    border-radius: var(--border-radius-2);
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
    background: var(--clr-white);
    box-shadow: var(--box-shadow);
    border-radius: var(--border-radius-2);
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
    border-radius: var(--border-radius-1);
    transition: border-color 0.3s;
}

input:focus {
    border-color: var(--clr-primary);
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
    border-radius: var(--border-radius-1);
    transition: background-color 0.3s, transform 0.2s;
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

/* Modal Styling delete */

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
    color: var(--clr-dark);
    padding: 15px;
    border-radius: 10px;
    max-width: 500px;
    width: 50%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.dialog-header,
.dialog-body,
.dialog-footer {
    margin-bottom: 15px;
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
    border-radius: var(--border-radius-1);
    cursor: pointer;
}

.confirm-btn:hover {
    background-color: #4cae4c;
}

.cancel-btn {
    padding: 8px 16px;
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-1);
    cursor: pointer;
    margin-left: 10px;
}

.cancel-btn:hover {
    background-color: #c9302c;
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

.modal-header,
.modal-body,
.modal-footer {
    margin-bottom: 10px;
    color: var(--clr-dark);
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
</style>
