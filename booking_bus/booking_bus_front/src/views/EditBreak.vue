<template>
    <div class="main-content">
        <NavBar />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Break List</p>
                </div>
                <select v-model="selectedGovernmentId" @change="fetchBreaks">
                    <option
                        v-for="government in governments"
                        :key="government.id"
                        :value="government.id"
                    >
                        {{ government.name }}
                    </option>
                </select>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Break ID</th>
                            <th>Break Name</th>
                            <th>Government Name</th>
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
        };
    },
    mounted() {
        this.fetchGovernments();
    },
    methods: {
        fetchGovernments() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.governments = response.data;
                    console.log(this.governments);
                })
                .catch((error) => {
                    window.alert("Error getting Government");
                    console.error(error);
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
                .catch((error) => {
                    window.alert("Error getting Breaks");
                    console.error(error);
                });
        },
        getGovernmentName(id) {
            const government = this.governments.find((gov) => gov.id === id);
            return government ? government.name : "Unknown";
        },
        cancelEdit() {
            this.editingIndex = null;
            this.name = "";
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
