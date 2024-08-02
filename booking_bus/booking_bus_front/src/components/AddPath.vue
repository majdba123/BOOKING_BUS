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
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name Start</th>
                            <th>Name End</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(path, index) in filteredPaths" :key="index">
                            <td>{{ path.id }}</td>
                            <td>{{ path.from }}</td>
                            <td>{{ path.to }}</td>
                            <td>
                                <button
                                    class="edit-btn"
                                    @click="openEditModal(path, index)"
                                >
                                    Edit
                                </button>
                                <button
                                    class="delete-btn"
                                    @click="DeletePath(path.id)"
                                >
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
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

                    <div class="map-container">
                        <MapPath />
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="" @click="updatePath">Update</button>
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
import MapPath from "./MapPath.vue";

export default {
    name: "AddPath",
    components: { MapPath },
    data() {
        return {
            showForm: true,
            Paths: [],
            StartPath: "",
            EndPath: "",
            showEditModal: false,
            editedPath: { from: "", to: "" },
            editingIndex: null,
        };
    },
    mounted() {
        this.AllPaths();
    },
    methods: {
        handleSubmit() {
            console.log("Form Submitted", this.nameStart, this.nameEnd);
        },
        CreatePath() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/path_store",
                data: {
                    from: this.StartPath,
                    to: this.EndPath,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status === 200) {
                        console.log(response);
                        window.alert("Path Created Successfully");
                        this.AllPaths();
                    }
                })
                .catch((error) => {
                    window.alert("Error Creating Path");
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
                })
                .catch((error) => {
                    window.alert("Error Getting Paths");
                    console.error(error);
                });
        },
        DeletePath(id) {
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
                })
                .catch((error) => {
                    window.alert("Error deleting path");
                    console.error(error);
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
            const access_token = window.localStorage.getItem("access_token");
            const pathId = this.editedPath.id;
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/path_update/${pathId}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    from: this.editedPath.from,
                    to: this.editedPath.to,
                },
            })
                .then((response) => {
                    this.Paths.splice(this.editingIndex, 1, this.editedPath);
                    this.editingIndex = null;
                    this.editedPath = { from: "", to: "" };
                    console.log(response);
                    window.alert("Complete update");
                    this.showEditModal = false;
                })
                .catch((error) => {
                    window.alert("Error updating path");
                    console.error(error);
                });
        },
    },
    computed: {
        filteredPaths() {
            return store.state.Paths.filter((path) => {
                return (
                    path.from
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    path.to
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase())
                );
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
.delete-btn,
.edit-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    border: none;
    transition: background-color 0.3s ease;
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
}

.form-containerd {
    display: flex;
    flex-direction: column;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    max-width: 400px;
    width: 100%;
}

.form-groupd {
    margin-bottom: 15px;
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
    transition: background-color 0.3s;
}

.submit-btnd:hover {
    background-color: #0056b3;
}

.map-container {
    flex: 1;
    margin-left: 20px;
    min-width: 400px;
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
</style>
