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
                        <tr v-for="(bus, index) in Bus" :key="index">
                            <td>
                                {{ bus.number_bus }}
                            </td>
                            <td>
                                {{ bus.number_passenger }}
                            </td>
                            <td>
                                <button @click="editPath(index)">Edit</button>
                            </td>
                            <td>
                                <button @click="DeleteBus(bus.id)">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div v-if="editingIndex !== null" class="edit-form">
                    <form @submit.prevent="saveChanges">
                        <label for="start">Start Path:</label>
                        <input type="text" id="start" v-model="start" />
                        <br />
                        <label for="end">End Path:</label>
                        <input type="text" id="end" v-model="editedPath.end" />
                        <br />
                        <button type="submit">Save Changes</button>
                        <button @click="cancelEdit">Cancel</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";
import axios from "axios";

export default {
    name: "EditeBus",
    component: { NavBarCompany },
    data() {
        return {
            editingIndex: null,
            Bus: "",
            id: "",
        };
    },
    mounted() {
        this.fetchBus();
    },
    methods: {
        fetchBus() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Bus = response.data;
                })
                .catch(function (error) {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
        DeleteBus(x) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "delete",
                url: "http://127.0.0.1:8000/api/company/delete_bus/" + x,

                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Deleted Complate");

                    window.location.reload();
                })
                .catch(function (error) {
                    window.alert("Error get Bus");
                    console.error(x);
                    console.error(error);
                });
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
</style>
