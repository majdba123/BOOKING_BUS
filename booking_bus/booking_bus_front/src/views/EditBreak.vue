<template>
    <div class="main-content">
        <NavBar />
        <div class="content">
            <div class="container">
                <div class="title">
                    <p>Break List</p>
                </div>

                <table class="table">
                    <thead>
                        <tr>
                            <th>Break ID</th>
                            <th>Break Name</th>
                            <th>
                                <select
                                    v-model="selectedGovernmentId"
                                    @change="fetchBreaks"
                                    class="select"
                                >
                                    <option
                                        v-for="government in governments"
                                        :key="government.id"
                                        :value="government.id"
                                    >
                                        {{ government.name }}
                                    </option>
                                </select>
                            </th>
                            <th>Edit</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(breakItem, index) in breaks" :key="index">
                            <td>{{ breakItem.id }}</td>
                            <td>{{ breakItem.name }}</td>
                            <td>
                                {{ getGovernmentName(breakItem.government_id) }}
                            </td>
                            <td>
                                <button @click="editBreak(index)">Edit</button>
                            </td>
                            <td>
                                <button @click="deleteBreak(breakItem.id)">
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
                            <label for="break_name">Break Name:</label>
                            <input type="text" id="break_name" v-model="name" />
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
import NavBar from "@/components/NavBar.vue";
import axios from "axios";

export default {
    name: "EditBreaks",
    components: { NavBar },
    data() {
        return {
            editingIndex: null,
            breaks: [],
            name: "",
            governments: [],
            selectedGovernmentId: null,
        };
    },
    mounted() {
        this.fetchData(); // Initial fetch of data
    },
    methods: {
        fetchData() {
            this.fetchGovernments();
        },
        fetchGovernments() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.governments = response.data;
                    if (this.governments.length > 0) {
                        this.selectedGovernmentId = this.governments[0].id;
                        this.fetchBreaks();
                    }
                })
                .catch(() => {
                    this.handleError("Error getting Governments");
                });
        },
        fetchBreaks() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/admin/all_breaks/${this.selectedGovernmentId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breaks = response.data;
                })
                .catch(() => {
                    this.handleError("Error getting Breaks");
                });
        },
        getGovernmentName(governmentId) {
            const government = this.governments.find(
                (gov) => gov.id === governmentId
            );
            return government ? government.name : "Unknown";
        },
        editBreak(index) {
            this.editingIndex = index;
            this.name = this.breaks[index].name;
        },
        saveChanges() {
            const access_token = window.localStorage.getItem("access_token");
            const breakId = this.breaks[this.editingIndex].id;
            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/admin/update_breaks/${breakId}`, // Corrected URL
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    name: this.name,
                },
            })
                .then(() => {
                    // console.log(response);
                    window.location.reload();
                    this.cancelEdit();
                })
                .catch(() => {
                    this.handleError("Error updating Break");
                });
        },
        deleteBreak(id) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/admin/delete_breaks/${id}`, // Corrected URL
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Break deleted successfully");
                    window.location.reload();
                })
                .catch(() => {
                    this.handleError("Error deleting Break");
                });
        },

        cancelEdit() {
            this.editingIndex = null;
            this.name = "";
        },
        handleError(message) {
            window.alert(message);
        },
    },
};
</script>

<style scoped>
* {
    margin: 0;
    padding: 0;
    outline: none;
    border: none;
    text-decoration: none;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
}
.content {
    flex: 1600%;
}
.main-content {
    display: flex;
    width: 100%;
}

.container {
    width: 90%;
    margin: 20px auto;
    text-align: center;
}
.container select {
    color: #000000;
    margin-top: 10px;
    font-size: 15px;
}
.container select option {
    color: #000000;
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
