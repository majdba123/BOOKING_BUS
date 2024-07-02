<template>
    <div class="continer">
        <div class="title">
            <p>Paths List</p>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th>Name Path</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(path, index) in paths" :key="index">
                    <td>{{ path.name }}</td>
                    <td>
                        <button @click="editPath(index)">Edit</button>
                    </td>
                    <td>
                        <button @click="deletePath(index, path.id)">
                            Delete
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>

        <div v-if="editingIndex !== null" class="edit-form">
            <form @submit.prevent="saveChanges">
                <label for="start">Start Path:</label>
                <input type="text" id="start" v-model="editedPath.start" />
                <br />
                <label for="end">End Path:</label>
                <input type="text" id="end" v-model="editedPath.end" />
                <br />
                <button type="submit">Save Changes</button>
                <button @click="cancelEdit">Cancel</button>
            </form>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    name: "EditPath",
    data() {
        return {
            paths: [],
            editingIndex: null,
            editedPath: {
                start: "",
                end: "",
            },
        };
    },
    async created() {
        await this.fetchPaths();
    },
    methods: {
        async fetchPaths() {
            try {
                const response = await axios({
                    method: "get",
                    url: "http://127.0.0.1:8000/api/company/all_path",
                    headers: {
                        Authorization: "access_token",
                    },
                });
                this.paths = response.data.paths;
            } catch (error) {
                window.alert("Error get paths");
                console.error(error);
            }
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
.continer {
    width: 70%;
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
