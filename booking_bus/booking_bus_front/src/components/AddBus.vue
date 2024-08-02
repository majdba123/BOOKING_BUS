<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">Add Bus</button>
            <button class="nav-btnd" @click="showForm = false">Edit Bus</button>
            <button class="nav-btnd">Button 3</button>
            <button class="nav-btnd">Button 4</button>
        </header>

        <div v-if="showForm" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="driverName">Number Bus</label>
                    <input
                        type="number"
                        id="driverAge"
                        v-model="number_bus"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverAge">Number Passenger</label>
                    <input
                        type="number"
                        id="driverAge"
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
                        </tr>
                    </thead>
                    <tbody>
                        <tr
                            v-for="(user, index) in filteredDrivers"
                            :key="index"
                        >
                            <td>{{ user.number_bus }}</td>
                            <td>{{ user.number_passenger }}</td>

                            <td>
                                <button
                                    class="edit-btn"
                                    @click="openEditModal(user, index)"
                                >
                                    Edit
                                </button>
                                <button
                                    class="delete-btn"
                                    @click="DeleteBus(user.id)"
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
                <div class="modal-header">Edit Bus</div>
                <div class="modal-body">
                    <label for="editNameStart">Number Bus</label>
                    <input
                        type="text"
                        id="editNameStart"
                        v-model="editedPath.number_bus"
                        required
                    />

                    <label for="editNameEnd">Number Passenger</label>
                    <input
                        type="text"
                        id="editNameEnd"
                        v-model="editedPath.number_passenger"
                        required
                    />
                </div>
                <div class="modal-footer">
                    <button class="edit-btn" @click="updateBus">Update</button>
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

export default {
    name: "AddBus",
    data() {
        return {
            Bus: [],
            editingIndex: null,
            showEditModal: false,

            showForm: true,
            number_bus: "",
            number_passenger: "",
            editedPath: { number_bus: "", number_passenger: "" },
        };
    },
    mounted() {
        this.AllBus();
    },
    methods: {
        closeEditModal() {
            this.showEditModal = false;
        },
        handleSubmit() {
            console.log(
                "Form Submitted",
                this.number_bus,
                this.number_passenger
            );
            // Add your form submission logic here
        },
        AddBus() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/store_bus",
                data: {
                    number_bus: this.number_bus,

                    number_passenger: this.number_passenger,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    console.log(response);
                    window.alert("Complete ADD");
                })
                .catch((error) => {
                    window.alert("ERROR ADD");
                    console.log(error);
                });
        },
        updateBus() {
            const access_token = window.localStorage.getItem("access_token");
            const busId = this.editedPath.id;
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/update_bus/${busId}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    number_bus: this.editedPath.number_bus,
                    number_passenger: this.editedPath.number_passenger,
                },
            })
                .then((response) => {
                    this.Bus.splice(this.editingIndex, 1, this.editedPath);
                    this.editingIndex = null;
                    this.editedPath = { number_bus: "", number_passenger: "" };
                    console.log(response);
                    window.alert("Complete update");
                    this.showEditModal = false;
                })
                .catch((error) => {
                    window.alert("Error updating path");
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
        openEditModal(path, index) {
            this.editedPath = { ...path };
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
                    this.Bus = this.Bus.filter(
                        (pathItem) => pathItem.id !== id
                    );
                })
                .catch((error) => {
                    window.alert("Error deleting path");
                    console.error(error);
                });
        },
    },
    watch: {
        filteredDriver() {
            console.log(store.state.searchQuery);
        },
    },
    computed: {
        filteredDrivers() {
            console.log(store.state.Bus);
            return store.state.Bus.filter((driver) => {
                return driver.number_bus
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
    display: block;
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
