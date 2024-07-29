<template>
    <div class="main-content">
        <NavBarUser />
        <div class="content">
            <div class="container">
                <div class="title">
                    <p>Trip List</p>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Trip ID</th>
                            <th>Name Of Company</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(trip, index) in Trip" :key="index">
                            <td>{{ trip.trip_id }}</td>

                            <td>{{ trip.company_id }}</td>
                            <td>{{ trip.from }}</td>
                            <td>{{ trip.to }}</td>
                            <td>{{ trip.price }}</td>
                        </tr>
                    </tbody>
                </table>
                <div v-if="selectedTrip" class="modal">
                    <div class="modal-content">
                        <span class="close" @click="closeDetails">&times;</span>
                        <h2>Trip Details</h2>
                        <div class="detail-section">
                            <p><strong>ID:</strong> {{ selectedTrip.id }}</p>
                            <p>
                                <strong>Status:</strong>
                                {{ selectedTrip.status }}
                            </p>
                            <p>
                                <strong>Price:</strong>
                                {{ selectedTrip.price }}
                            </p>
                            <p>
                                <strong>Company ID:</strong>
                                {{ selectedTrip.company_id }}
                            </p>
                            <p>
                                <strong>Created At:</strong>
                                {{ selectedTrip.created_at }}
                            </p>
                            <p>
                                <strong>Updated At:</strong>
                                {{ selectedTrip.updated_at }}
                            </p>
                        </div>
                        <div class="detail-section">
                            <h3>Breaks</h3>
                            <ul>
                                <li
                                    v-for="breakItem in selectedTrip.breaks_trip"
                                    :key="breakItem.id"
                                >
                                    Break ID: {{ breakItem.breaks_id }}
                                </li>
                            </ul>
                        </div>
                        <div class="detail-section">
                            <h3>Buses</h3>
                            <ul>
                                <li
                                    v-for="bus in selectedTrip.bus_trip"
                                    :key="bus.id"
                                >
                                    Bus ID: {{ bus.bus_id }}, Type:
                                    {{ bus.type }}, Start Time:
                                    {{ bus.start_time }}, End Time:
                                    {{ bus.end_time }}
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div v-if="editingIndex !== null" class="modal">
                    <div class="modal-content">
                        <span class="close" @click="cancelEdit">&times;</span>
                        <h2>Edit Trip</h2>
                        <div class="contentt2">
                            <div class="box">
                                <div class="field">
                                    <span>Path</span>
                                    <select v-model="path" class="input">
                                        <option
                                            v-for="(pathItem, index) in paths"
                                            :key="index"
                                            :value="pathItem.id"
                                        >
                                            {{ pathItem.from }} >>
                                            {{ pathItem.to }}
                                        </option>
                                    </select>
                                </div>
                                <div class="field">
                                    <span>Price</span>
                                    <input
                                        type="text"
                                        class="input"
                                        placeholder="Enter Price"
                                        v-model="price"
                                    />
                                </div>
                                <div class="field">
                                    <span>Area</span>
                                    <select
                                        v-model="area"
                                        class="input"
                                        @change="fetchBreak"
                                    >
                                        <option
                                            v-for="(
                                                areaItem, index
                                            ) in Government"
                                            :key="index"
                                            :value="areaItem.id"
                                        >
                                            {{ areaItem.name }}
                                        </option>
                                    </select>
                                </div>
                                <div class="field">
                                    <span>Search Break Areas</span>
                                    <select
                                        v-model="search_break_areas"
                                        class="input multi-select"
                                        multiple
                                    >
                                        <option
                                            v-for="(breakItem, index) in breaks"
                                            :key="index"
                                            :value="breakItem.id"
                                        >
                                            {{ breakItem.name }}
                                        </option>
                                    </select>
                                </div>
                                <div class="field">
                                    <span>Bus</span>
                                    <div
                                        v-for="(bus, index) in buses"
                                        :key="index"
                                        class="bus-field"
                                    >
                                        <select
                                            v-model="bus.bus_id"
                                            class="input"
                                        >
                                            <option
                                                v-for="(
                                                    busItem, i
                                                ) in availableBuses"
                                                :key="i"
                                                :value="busItem.id"
                                            >
                                                {{ busItem.number_bus }}
                                            </option>
                                        </select>
                                        <span>Type</span>

                                        <select
                                            v-model="bus.type"
                                            class="input"
                                        >
                                            <option value="all">All</option>
                                            <option value="going">Going</option>
                                        </select>
                                        <span>Start Time</span>

                                        <input
                                            v-model="bus.start_time"
                                            type="time"
                                            class="input"
                                        />
                                        <span>End Time</span>

                                        <input
                                            v-model="bus.end_time"
                                            type="time"
                                            class="input"
                                        />
                                        <button
                                            @click="removeBus(index)"
                                            class="Button remove-bus-button"
                                        >
                                            Remove Bus
                                        </button>
                                    </div>
                                    <button
                                        @click="addBus"
                                        class="Button add-bus-button"
                                    >
                                        Add Another Bus
                                    </button>
                                </div>
                                <div class="field">
                                    <span>Date</span>
                                    <input
                                        type="date"
                                        class="input"
                                        v-model="date"
                                    />
                                </div>
                            </div>
                            <button class="Button" @click="AddTrip">ADD</button>
                        </div>
                        <button class="Button" @click="saveChanges">
                            Save
                        </button>
                        <button class="Button" @click="cancelEdit">
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarUser from "@/components/NavBarUser.vue";
import axios from "axios";

export default {
    name: "AllTripUser",
    components: { NavBarUser },
    data() {
        return {
            start_time: "",
            end_time: "",
            date: "",
            Trip: [],
            paths: [],
            Government: [],
            availableBuses: [],
            breaks: [],
            editingIndex: null,
            selectedTrip: null,
            path: "",
            price: "",
            area: "",
            search_break_areas: [],
            editedPath: {
                path_id: "",
                price: "",
                area: "",
                search_break_areas: [],
                buses: [
                    {
                        bus_id: "",
                        type: "all",
                        start_time: "",
                        end_time: "",
                        date: "",
                    },
                ],
                date: "",
            },
        };
    },
    mounted() {
        this.fetchTrip();
        this.fetchPaths();
        this.fetchGovernment();
        this.fetchAvailableBuses();
    },
    methods: {
        fetchTrip() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/user/trips",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Trip = response.data;
                    console.log(this.Trip);
                })
                .catch((error) => {
                    window.alert("Error fetching trips");
                    console.error(error);
                });
        },
        fetchTripDetails(tripId) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/show_trip/${tripId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.selectedTrip = response.data[0];
                })
                .catch((error) => {
                    window.alert("Error fetching trip details");
                    console.error(error);
                });
        },
        closeDetails() {
            this.selectedTrip = null;
        },
        editPath(index) {
            this.editingIndex = index;
            this.editedPath = JSON.parse(JSON.stringify(this.Trip[index]));
            this.fetchBreak(); // لجلب البيانات المناسبة للـ area
        },
        cancelEdit() {
            this.editingIndex = null;
            this.resetEditedPath();
        },
        DeleteTrip(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_trip/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Deleted Complete");
                    this.fetchTrip();
                })
                .catch((error) => {
                    window.alert("Error deleting trip");
                    console.error(error);
                });
        },
        saveChanges() {
            const access_token = window.localStorage.getItem("access_token");
            const tripId = this.Trip[this.editingIndex].id;

            if (!this.editedPath.buses) {
                window.alert("Error: No buses defined.");
                return;
            }

            const busIds = this.editedPath.buses.map((bus) => ({
                bus_id: bus.bus_id,
                type: bus.type,
                start_time: bus.start_time,
                end_time: bus.end_time,
                date: this.editedPath.date,
            }));

            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/update_trip/${tripId}`,
                headers: { Authorization: `Bearer ${access_token}` },
                data: {
                    path_id: this.editedPath.path_id,
                    price: this.editedPath.price,
                    area: this.editedPath.area,
                    breaks_ids: this.editedPath.search_break_areas,
                    bus_ids: busIds,
                },
            })
                .then(() => {
                    this.Trip.splice(this.editingIndex, 1, this.editedPath);
                    this.editingIndex = null;
                    this.resetEditedPath();
                    window.alert("Complete update");
                })
                .catch((error) => {
                    window.alert("Error updating path");
                    console.error(error);
                });
        },
        fetchPaths() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_path",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.paths = response.data;
                })
                .catch((error) => {
                    window.alert("Error getting paths");
                    console.error(error);
                });
        },
        fetchGovernment() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Government = response.data;
                })
                .catch((error) => {
                    window.alert("Error getting Government");
                    console.error(error);
                });
        },
        fetchAvailableBuses() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.availableBuses = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error getting buses");
                    console.error(error);
                });
        },
        fetchBreak() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_breaks/${this.area}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breaks = response.data;
                })
                .catch((error) => {
                    window.alert("Error getting breaks");
                    console.error(error);
                });
        },
        addBus() {
            this.editedPath.buses.push({
                bus_id: "",
                type: "all",
                start_time: "",
                end_time: "",
                date: "",
            });
        },
        removeBus(index) {
            this.editedPath.buses.splice(index, 1);
        },
        resetEditedPath() {
            this.editedPath = {
                path_id: "",
                price: "",
                area: "",
                search_break_areas: [],
                buses: [
                    {
                        bus_id: "",
                        type: "all",
                        start_time: "",
                        end_time: "",
                        date: "",
                    },
                ],
                date: "",
            };
        },
    },
};
</script>
<style scoped>
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

.box {
    display: flex;
    flex-direction: column;
    margin: 0 auto; /* توسيط النموذج أفقيًا */
    padding: 20px;
    background-color: white;
    border-radius: 15px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    text-align: center;
    font-size: 18px;
    gap: 20px;
    max-width: 100%; /* يضمن عدم تجاوز النموذج للحاوية */
}

.field {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.modal-content {
    background-color: #fefefe;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    max-width: 500px;
    border-radius: 10px;
    text-align: left;
    background-color: rgba(0, 0, 0, 0.5);
}

.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

.main-content {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    min-height: 100vh;
    background-color: #f0f4f8;
}

.content {
    display: block;
    width: 100%;
    max-width: 800px; /* عرض النموذج بحد أقصى */
    padding: 20px;
}

.container {
    display: block;
    text-align: center;
    padding: 20px;
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
    width: 100%;
    font-size: 13px;
    margin: 20px 0;
    border: 1px solid #ddd;
}

.table thead tr {
    background: #176b87;
    text-align: center;
    font-weight: bold;
    color: white;
}

.table th,
.table td {
    padding: 12px 15px;
    text-align: center;
    border: 1px solid #ddd;
}

.table th {
    color: white;
}

.table td {
    color: #000000;
    background: #f9f9f9;
}

.table button {
    padding: 6px 20px;
    border-radius: 10px;
    cursor: pointer;
    color: #fff;
    background-color: #176b87;
    border: 1px solid #ffffff;
}
.table button {
    padding: 6px 12px;
    border-radius: 5px;
    cursor: pointer;
    color: #fff;
    background-color: #176b87;
    border: none;
    transition: background-color 0.3s;
}

.table button:hover {
    background: #204e5e;
    color: #fff;
}

.detail-section {
    margin-bottom: 20px;
}

.detail-section h3 {
    margin-bottom: 10px;
    color: #176b87;
}

.detail-section p {
    margin: 5px 0;
    color: black;
}

.detail-section ul {
    list-style-type: none;
    padding: 0;
}

.detail-section ul li {
    background: #f1f1f1;
    padding: 10px;
    margin-bottom: 5px;
    border-radius: 5px;
    color: black;
}
.field span {
    color: #333;
    font-weight: 500;
    font-size: 16px;
}

.input {
    width: 100%;
    height: 40px;
    border-radius: 5px;
    border: 1px solid #ddd;
    padding: 0 12px;
    font-size: 16px;
    background-color: #fff;
    box-sizing: border-box;
    transition: border-color 0.3s ease;
}

.input::placeholder {
    color: #bbb;
}

.input:focus {
    border-color: #007bff;
    outline: none;
}

.multi-select {
    height: auto;
    max-height: 100px;
    overflow-y: auto;
}

.Button {
    background-color: #007bff;
    color: #fff;
    padding: 10px 20px;
    border-radius: 5px;
    border: none;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-top: 20px; /* إضافة مسافة بين الأزرار */
}

.Button:hover {
    background-color: #0056b3;
}

.Button:focus {
    outline: none;
}

.remove-bus-button {
    background-color: #dc3545;
}

.remove-bus-button:hover {
    background-color: #c82333;
}

.add-bus-button {
    margin-top: 10px;
    background-color: #28a745;
}

.add-bus-button:hover {
    background-color: #218838;
}

.bus-field {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-bottom: 10px;
}
</style>
