<template>
    <div class="containerd">
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">Add Path</button>
            <button class="nav-btnd" @click="showForm = false">
                Show Path
            </button>
        </header>
        <div class="content">
            <div class="form-map-container" v-if="showForm">
                <div class="form-container">
                    <form @submit.prevent="handleSubmit" class="break-form">
                        <div class="form-group">
                            <label for="breakName">Name Break</label>
                            <input
                                type="text"
                                id="breakName"
                                placeholder="Enter Name Break"
                                v-model="name"
                                required
                            />
                        </div>
                        <div class="form-group">
                            <label for="government">
                                <span class="material-icons"
                                    >location_city</span
                                >
                                Select Government
                            </label>
                            <select
                                id="government"
                                v-model="government"
                                required
                                class="custom-select"
                            >
                                <option value="" disabled>
                                    Select Government
                                </option>
                                <option
                                    v-for="gov in governments"
                                    :key="gov.id"
                                    :value="gov.id"
                                >
                                    {{ gov.name }}
                                </option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="description">
                                <span class="material-icons">description</span>
                                Description
                            </label>
                            <textarea
                                id="description"
                                placeholder="Enter a brief description"
                                v-model="description"
                                rows="3"
                                required
                            ></textarea>
                        </div>
                        <div class="submit-btn">
                            <button type="submit">ADD</button>
                        </div>
                    </form>
                </div>
                <div class="map-container">
                    <MapPath />
                </div>
            </div>
            <div v-else class="recent_orders">
                <h1>All Breaks</h1>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Name Break</th>
                                <th>Government</th>
                                <th>Description</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(breakItem, index) in breaks"
                                :key="index"
                            >
                                <td>{{ breakItem.name }}</td>
                                <td>{{ breakItem.government }}</td>
                                <td>{{ breakItem.description }}</td>
                                <td>
                                    <button
                                        class="edit-btn"
                                        @click="openEditModal(breakItem, index)"
                                    >
                                        Edit
                                    </button>
                                    <button
                                        class="delete-btn"
                                        @click="DeleteBreak(breakItem.id)"
                                    >
                                        Delete
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import MapPath from "./MapPath.vue";

export default {
    name: "AddBreak",
    components: { MapPath },
    data() {
        return {
            showForm: true,
            break: {
                name: "",
                government: "",
                description: "",
            },
            governments: [],
            breaks: [],
        };
    },
    methods: {
        fetchGovernment() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.governments = response.data;
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
                url: "http://127.0.0.1:8000/api/admin/all_breaks",
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
        handleSubmit() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/admin/store_breaks",
                data: this.break,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Complete ADD");
                    this.fetchBreaks();
                })
                .catch((error) => {
                    window.alert("ERROR ADD");
                    console.error(error);
                });
        },
        DeleteBreak(breakId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/admin/delete_breaks/${breakId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Deleted Complete");
                    this.fetchBreaks();
                })
                .catch((error) => {
                    window.alert("Error deleting Break");
                    console.error(error);
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

.containerd {
    padding: 20px;
    background: #f6f6f9;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
}

.header {
    width: 100%;
}

.content {
    width: 100%;
    max-width: 1200px;
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.form-map-container {
    display: flex;
    gap: 10px;
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: var(--box-shadow);
    width: 100%;
}

.form-container {
    display: flex;
    flex-direction: column;
    gap: 15px;
    flex: 1;
}

/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    width: 100%;
    max-width: 1200px;
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
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    font-weight: 500;
    color: #363949;
}

label .material-icons {
    margin-right: 8px;
}

input,
select,
textarea {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    width: 100%;
    font-size: 1rem;
}

input:focus,
select:focus,
textarea:focus {
    border-color: #007bff;
}

.submit-btn {
    margin: 10px;
    text-align: center;
}

.submit-btn button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.submit-btn button:hover {
    background-color: #0056b3;
}

.map-container {
    flex: 1;
    min-width: 400px;
    height: 400px;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: var(--box-shadow);
    padding: 10px;
    margin-bottom: 30px;
}

/* Custom Select styling */
.custom-select {
    appearance: none;
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    font-size: 1rem;
    transition: border-color 0.3s;
}
.custom-select option {
    color: #007bff;
}
.custom-select:focus {
    border-color: #007bff;
}

/* Table styling */
.table-container {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: var(--box-shadow);
}

table th,
table td {
    padding: 12px 15px;
    text-align: center;
    border-bottom: 1px solid #ddd;
}

table th {
    background-color: var(--clr-primary);
    color: #fff;
}

table tbody tr:nth-child(even) {
    background-color: #f2f2f2;
}

table tbody tr:hover {
    background-color: #f1f1f1;
}

.edit-btn,
.delete-btn,
.status-btn {
    padding: 5px 10px;
    margin: 5px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.edit-btn {
    background-color: #4caf50;
    color: white;
}

.edit-btn:hover {
    background-color: #45a049;
}

.delete-btn {
    background-color: #f44336;
    color: white;
}

.delete-btn:hover {
    background-color: #e53935;
}

.status-btn {
    background-color: #2196f3;
    color: white;
}

.status-btn:hover {
    background-color: #1e88e5;
}
</style>
