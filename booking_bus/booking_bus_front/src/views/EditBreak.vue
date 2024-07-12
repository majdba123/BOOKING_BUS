<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Bus List</p>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Number Bus</th>
                            <th>Number Passenger</th>
                            <th>Edit</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(bus, index) in buses" :key="index">
                            <td>{{ bus.number_bus }}</td>
                            <td>{{ bus.number_passenger }}</td>
                            <td>
                                <button @click="editBus(index)">Edit</button>
                            </td>
                            <td>
                                <button @click="deleteBus(bus.id)">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div v-if="editingIndex !== null" class="modal">
                    <div class="modal-content">
                        <span class="close" @click="cancelEdit">&times;</span>
                        <form @submit.prevent="saveChanges">
                            <label for="number_bus">Number Bus:</label>
                            <input
                                type="text"
                                id="number_bus"
                                v-model="number_bus"
                            />
                            <br />
                            <label for="number_passenger"
                                >Number Passenger:</label
                            >
                            <input
                                type="text"
                                id="number_passenger"
                                v-model="number_passenger"
                            />
                            <br />
                            <button type="submit">Save Changes</button>
                            <button type="button" @click="cancelEdit">
                                Cancel
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";
import axios from "axios";

export default {
    name: "EditBreack",
    components: { NavBarCompany },
    data() {
        return {
            editingIndex: null,
            buses: [],

            number_bus: "",
            number_passenger: "",
        };
    },
    mounted() {
        this.fetchBuses();
    },
    methods: {
        fetchBuses() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.buses = response.data;
                    console.log(this.buses);
                })
                .catch((error) => {
                    window.alert("Error getting buses");
                    console.error(error);
                });
        },
        deleteBus(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_bus/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Deleted Complete");
                    window.location.reload();
                })
                .catch((error) => {
                    window.alert("Error deleting bus");
                    console.error(error);
                });
        },
        editBus(index) {
            this.editingIndex = index;
            this.editedBus = { ...this.buses[index] };
        },
        saveChanges() {
            const access_token = window.localStorage.getItem("access_token");
            const busId = this.buses[this.editingIndex].id;

            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/update_bus/${busId}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    number_bus: this.number_bus,
                    number_passenger: this.number_passenger,
                },
            })
                .then((response) => {
                    console.log(response);
                    window.alert("Bus updated successfully");
                })
                .catch((error) => {
                    window.alert("Error updating bus");
                    console.error(error);
                });
        },
        cancelEdit() {
            this.editingIndex = null;
            this.editedBus = { number_bus: null, number_passenger: null };
        },
    },
};
</script>

<style scoped>
.main-content {
    display: flex;
    width: 100%;
}
.content {
    flex: 1600%;
}
* {
    margin: 0;
    padding: 0;
    outline: none;
    border: none;
    text-decoration: none;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
}
.continer {
    width: 90%;
    margin: 20px auto;
    text-align: center;
}
.title p {
    padding: 15px;
    background-color: #176b87;
    border-radius: 15px;
    text-align: center;
    font-size: 26px;
    color: white;
}
.table {
    border-collapse: collapse;
    table-layout: fixed;
    width: 100%;
    font-size: 13px;
    min-width: 100%;
    overflow: hidden;
    border-radius: 4px;
    margin: 11px auto;
}
.table thead tr {
    background: #176b87;
    text-align: left;
    font-weight: bold;
    color: white;
}
.table th,
.table td {
    padding: 12px 15px;
    text-align: center;
    word-break: break-all;
}
.table th {
    color: white;
}
.table td {
    color: #000000;
    background: #e9e9e9;
}
.table button {
    padding: 6px 20px;
    border-radius: 10px;
    cursor: pointer;
    color: #fff;
    background-color: #176b87;
    border: 1px solid #ffffff;
}
.table button a {
    color: #fff;
}
.table button:hover {
    background: #204e5e;
    color: #fff;
    transition: 0.5s;
}
tr td a {
    color: #000000;
}
tr td a:hover,
.dd:hover {
    color: #ffffff;
}
.edit-form label,
button {
    color: #000000;
}
.edit-form button {
    margin-top: 10px;
    padding: 10px;
    width: 50%;
    align-items: center;
    border-radius: 6px;
}

/* Modal styles */
.modal {
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
}
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    max-width: 500px;
    border-radius: 10px;
    text-align: center;
}
.modal-content label {
    color: #000000;
}
.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}
.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
</style>
