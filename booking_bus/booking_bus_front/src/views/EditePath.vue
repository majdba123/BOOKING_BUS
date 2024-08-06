<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="container">
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
                        <tr v-for="(pathItem, index) in path" :key="index">
                            <td>{{ pathItem.from }} >> {{ pathItem.to }}</td>
                            <td>
                                <button @click="editPath(index)">Edit</button>
                            </td>
                            <td>
                                <button @click="deletePath(pathItem.id)">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Edit Modal -->
                <div v-if="editingIndex !== null" class="modal">
                    <div class="modal-content">
                        <span class="close" @click="cancelEdit">&times;</span>
                        <form @submit.prevent="saveChanges">
                            <label for="start">Start Path:</label>
                            <input
                                type="text"
                                id="start"
                                v-model="editedPath.from"
                            />
                            <br />
                            <label for="end">End Path:</label>
                            <input
                                type="text"
                                id="end"
                                v-model="editedPath.to"
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
    name: "EditPath",
    components: { NavBarCompany },
    data() {
        return {
            editingIndex: null,
            path: [],
            editedPath: {
                from: "",
                to: "",
            },
        };
    },
    mounted() {
        this.fetchPaths();
    },
    methods: {
        fetchPaths() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_path",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.path = response.data;
                    console.log(this.path);
                })
                .catch((error) => {
                    window.alert("Error getting paths");
                    console.error(error);
                });
        },

        editPath(index) {
            this.editingIndex = index;
            this.editedPath = { ...this.path[index] };
        },

        saveChanges() {
            const access_token = window.localStorage.getItem("access_token");
            const pathId = this.path[this.editingIndex].id;

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
                    this.path.splice(this.editingIndex, 1, this.editedPath);
                    this.editingIndex = null;
                    this.editedPath = { from: "", to: "" };
                    console.log(response);
                    window.alert("Complete update");
                })
                .catch((error) => {
                    window.alert("Error updating path");
                    console.error(error);
                });
        },

        cancelEdit() {
            this.editingIndex = null;
            this.editedPath = { from: "", to: "" };
        },

        deletePath(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/path_delete/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.path = this.path.filter(
                        (pathItem) => pathItem.id !== id
                    );
                })
                .catch((error) => {
                    window.alert("Error deleting path");
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
.container {
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
