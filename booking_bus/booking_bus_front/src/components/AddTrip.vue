<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">Add Trip</button>
            <button class="nav-btnd" @click="showForm = false">
                Show Trips
            </button>
            <button class="nav-btnd" @click="showTripStatusModal = true">
                Trip Status
            </button>
        </header>
        <div v-if="showTripStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Trip Status</div>
                <div class="modal-body">
                    <button
                        class="status-btn"
                        @click="fetchTripStatus('padding')"
                    >
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchTripStatus('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchTripStatus('finished')"
                    >
                        Finished
                    </button>
                    <table>
                        <thead>
                            <tr>
                                <th>Trip ID</th>
                                <th>Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(trip, index) in tripStatusData"
                                :key="index"
                            >
                                <td>{{ trip.id }}</td>
                                <td>{{ trip.price }}</td>
                                <td>{{ trip.status }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button @click="closeTripStatusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showForm" class="form-map-container">
            <form @submit.prevent="handleSubmit" class="form-containerd">
                <div class="form-groupd">
                    <label for="path">Path</label>
                    <select v-model="path" class="input">
                        <option
                            v-for="(pathItem, index) in paths"
                            :key="index"
                            :value="pathItem.id"
                        >
                            {{ pathItem.from }} >> {{ pathItem.to }}
                        </option>
                    </select>
                </div>
                <div class="form-groupd">
                    <label for="price">Price</label>
                    <input type="text" id="price" v-model="price" required />
                </div>
                <div class="form-groupd">
                    <label for="area">Area</label>
                    <select v-model="area" class="input" @change="fetchBreak">
                        <option
                            v-for="(areaItem, index) in Government"
                            :key="index"
                            :value="areaItem.id"
                        >
                            {{ areaItem.name }}
                        </option>
                    </select>
                </div>
                <div class="form-groupd">
                    <label for="search_break_areas">Search Break Areas</label>
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
                <div class="form-groupd">
                    <label for="bus">Bus</label>
                    <div
                        v-for="(bus, index) in buses"
                        :key="index"
                        class="bus-field"
                    >
                        <select v-model="bus.bus_id" class="input">
                            <option
                                v-for="(busItem, i) in availableBuses"
                                :key="i"
                                :value="busItem.id"
                            >
                                {{ busItem.number_bus }}
                            </option>
                        </select>
                        <span>Type</span>
                        <select v-model="bus.type" class="input">
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
                    <button @click="addBus" class="Button add-bus-button">
                        Add Another Bus
                    </button>
                </div>
                <div class="form-groupd">
                    <label for="date">Date</label>
                    <input type="date" id="date" v-model="date" required />
                </div>
                <div class="submit-btnnd">
                    <button type="submit" @click="AddTrip" class="submit-btnd">
                        Submit
                    </button>
                </div>
            </form>
        </div>

        <div v-else class="recent_orders">
            <h1>All Trips</h1>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Trip ID</th>
                            <th>Status</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Price</th>
                            <th>Details</th>
                            <th>Delete</th>
                            <th>Edit</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(trip, index) in filteredTrips" :key="index">
                            <td>{{ trip.id }}</td>
                            <td>{{ trip.status }}</td>
                            <td>{{ trip.path?.from }}</td>
                            <td>{{ trip.path?.to }}</td>
                            <td>{{ trip.price }}</td>
                            <td>
                                <button
                                    class="Button details-btn"
                                    @click="fetchTripDetails(trip.id)"
                                >
                                    <span class="material-icons"> info </span>
                                </button>
                            </td>
                            <td>
                                <button
                                    class="Button delete-btn"
                                    @click="DeleteTrip(trip.id)"
                                >
                                    <span class="material-icons">delete</span>
                                </button>
                            </td>
                            <td>
                                <button
                                    class="Button edit-btn"
                                    @click="editTrip(index, trip.id)"
                                >
                                    <span class="material-icons">edit</span>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div v-if="selectedTrip" class="modal">
            <div class="modal-content">
                <span class="close" @click="closeDetails">&times;</span>
                <h2>Trip Details</h2>
                <div class="detail-section">
                    <p><strong>ID:</strong> {{ selectedTrip.id }}</p>
                    <p><strong>Status:</strong> {{ selectedTrip.status }}</p>
                    <p><strong>Price:</strong> {{ selectedTrip.price }}</p>
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
                        <li v-for="bus in selectedTrip.bus_trip" :key="bus.id">
                            Bus ID: {{ bus.bus_id }}, Type: {{ bus.type }},
                            Start Time: {{ bus.start_time }}, End Time:
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
                <div class="form-groupd">
                    <label for="path">Path</label>
                    <select v-model="path" class="input" required>
                        <option
                            v-for="(pathItem, index) in paths"
                            :key="index"
                            :value="pathItem.id"
                        >
                            {{ pathItem.from }} >> {{ pathItem.to }}
                        </option>
                    </select>
                </div>
                <div class="form-groupd">
                    <label for="price">Price</label>
                    <input type="text" id="price" v-model="price" required />
                </div>

                <div class="form-groupd">
                    <label for="area">Area</label>
                    <select
                        v-model="area"
                        class="input"
                        @change="fetchBreak"
                        required
                    >
                        <option
                            v-for="(areaItem, index) in Government"
                            :key="index"
                            :value="areaItem.id"
                        >
                            {{ areaItem.name }}
                        </option>
                    </select>
                </div>

                <div class="form-groupd">
                    <label for="search_break_areas">Search Break Areas</label>
                    <select
                        v-model="search_break_areas"
                        class="input multi-select"
                        multiple
                        required
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

                <div class="form-groupd">
                    <label for="bus">Bus</label>
                    <div
                        v-for="(bus, index) in buses"
                        :key="index"
                        class="bus-field"
                    >
                        <select v-model="bus.bus_id" class="input" required>
                            <option
                                v-for="(busItem, i) in availableBuses"
                                :key="i"
                                :value="busItem.id"
                            >
                                {{ busItem.number_bus }}
                            </option>
                        </select>
                        <label>Type</label>
                        <select v-model="bus.type" class="input">
                            <option value="all">All</option>
                            <option value="going">Going</option>
                        </select>
                        <label>Start Time</label>
                        <input
                            v-model="bus.start_time"
                            type="time"
                            class="input"
                        />
                        <label>End Time</label>
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
                    <button @click="addBus" class="Button add-bus-button">
                        Add Another Bus
                    </button>
                </div>
                <div class="form-groupd">
                    <label for="date">Date</label>
                    <input type="date" id="date" v-model="date" />
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="saveChanges()"
                        class="submit-btnd"
                    >
                        Save Changes
                    </button>
                    <button
                        @click="cancelEdit"
                        class="submit-btnd"
                        type="button"
                    >
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
import { useToast } from "vue-toastification";

export default {
    name: "AddTrip",
    data() {
        return {
            x: "",
            showForm: true,
            Trips: [],
            paths: [],
            Government: [],
            availableBuses: [],
            breaks: [],
            path: "",
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
            buse: [
                {
                    path_id: "",
                    price: "",
                    area_id: "",
                    break_areas: [],
                    buses: [],
                    date: "",
                },
            ],
            date: "",
            showEditModal: false,
            selectedTrip: null,
            editedTrip: {
                path_id: "",
                price: "",
                area_id: "",
                break_areas: [],
                buses: [],
                date: "",
            },
            editingIndex: null,
            toast: useToast(),
            showTripStatusModal: false,
            tripStatusData: [],
        };
    },
    mounted() {
        this.fetchPaths();
        this.fetchGovernment();
        this.fetchAvailableBuses();
        this.AllTrips();
    },
    methods: {
        handleSubmit() {
            console.log(
                "Form Submitted",
                this.path,
                this.price,
                this.area,
                this.date
            );
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
            this.buses.push({
                bus_id: "",
                type: "",
                start_time: "",
                end_time: "",
                date: "",
            });
        },
        fetchBreakk(areaId) {
            const access_token = window.localStorage.getItem("access_token");
            console.log("Fetching breaks for area ID:", areaId); // لطباعة ID المنطقة في الconsole

            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_breaks/${areaId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breaks = response.data;
                    console.log("Breaks fetched successfully:", this.breaks); // طباعة البيانات المجلوبة
                })
                .catch((error) => {
                    console.error("Error getting breaks:", error); // طباعة الخطأ في الconsole
                    window.alert("Error getting breaks");
                });
        },
        removeBus(index) {
            this.buses.splice(index, 1);
        },
        AddTrip() {
            const token = window.localStorage.getItem("access_token");

            const busIds = this.buses.map((bus) => ({
                bus_id: bus.bus_id,
                type: bus.type,
                start_time: bus.start_time,
                end_time: bus.end_time,
                date: this.date,
            }));

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/store_trip",
                data: {
                    path_id: this.path,
                    price: this.price,
                    area: this.area,
                    breaks_ids: this.search_break_areas,
                    bus_ids: busIds,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    console.log(response);
                    this.toast.success("Trip Added Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.AllTrips();
                })
                .catch((error) => {
                    this.toast.error("Error Adding Trip", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.error(error);
                    console.log(this.date);
                });
        },
        AllTrips() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_trips",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Trips = response.data;
                    store.state.Trips = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    this.toast.error("Error Getting Trips", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.error(error);
                });
        },
        DeleteTrip(id) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_trip/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.Trips = this.Trips.filter(
                        (tripItem) => tripItem.id !== id
                    );
                    this.toast.success("Trip Deleted Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    this.AllTrips();
                })
                .catch((error) => {
                    this.toast.error("Error Deleting Trip", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
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
                    console.log(response);
                })
                .catch((error) => {
                    window.alert("Error fetching trip details");
                    console.error(error);
                });
        },
        closeDetails() {
            this.selectedTrip = null;
        },
        editTrip(index, x) {
            this.editingIndex = index;
            this.x = x;
            console.log(this.x);
        },
        cancelEdit() {
            this.editingIndex = null;
            this.resetEditedTrip();
        },
        saveChanges() {
            const token = window.localStorage.getItem("access_token");

            const busIds = this.buses.map((bus) => ({
                bus_id: bus.bus_id,
                type: bus.type,
                start_time: bus.start_time,
                end_time: bus.end_time,
                date: this.date,
            }));

            axios({
                method: "put",
                url: "http://127.0.0.1:8000/api/company/update_trip/" + this.x,
                headers: { Authorization: `Bearer ${token}` },
                data: {
                    path_id: this.path,
                    price: this.price,
                    area: this.area,
                    breaks_ids: this.search_break_areas,
                    bus_ids: busIds,
                },
            })
                .then((response) => {
                    console.log(response);

                    this.Trips.splice(this.editingIndex, 1, this.editedTrip);
                    this.editingIndex = null;
                    this.resetEditedTrip();
                    this.toast.success("Trip Updated Successfully", {
                        transition: "Vue-Toastification__bounce",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                })
                .catch((error) => {
                    this.toast.error("Error Updating Trip", {
                        transition: "Vue-Toastification__shake",
                        hideProgressBar: true,
                        closeOnClick: true,
                        pauseOnFocusLoss: false,
                        pauseOnHover: true,
                        draggable: true,
                        draggablePercent: 0.6,
                    });
                    console.error(error);
                });
        },
        fetchTripStatus(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_trips_by_status?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.tripStatusData = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching trip status");
                    console.error(error);
                });
        },
        closeTripStatusModal() {
            this.showTripStatusModal = false;
        },
        addBusToEdit() {
            this.editedTrip.buses.push({
                bus_id: "",
                type: "all",
                start_time: "",
                end_time: "",
                date: "",
            });
        },
        removeBusFromEdit(index) {
            this.editedTrip.buses.splice(index, 1);
        },
        resetEditedTrip() {
            this.editedTrip = {
                path_id: "",
                price: "",
                area_id: "",
                break_areas: [],
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
    computed: {
        filteredTrips() {
            if (!store.state.Trips) {
                return [];
            }
            return store.state.Trips.filter((trip) => {
                const pathName = trip.path
                    ? `${trip.path.from} >> ${trip.path.to}`
                    : "";
                return (
                    pathName
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    (trip.area_name || "")
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
    padding: 10px;
    border: 2px solid #007bff;
    border-radius: 5px;
    background-color: #f6f6f9;
    color: #363949;
    font-size: 16px;
    width: 100%;
    transition: border-color 0.3s ease;
}

select:focus {
    border-color: #0056b3;
    outline: none;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: 600;
    color: #363949;
    font-size: 16px;
}

/* Adjusted Button styling */
.delete-btn,
.edit-btn,
.status-btn,
.details-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    border: none;
    transition: background-color 0.3s ease;
    color: white;
    margin: 0 5px;
    display: flex;
    justify-content: center;
    align-items: center; /* Centers the icon and text */
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

.status-btn {
    background-color: #007bff;
    margin-bottom: 10px;
}

.status-btn:hover {
    background-color: #0056b3;
}

.details-btn {
    background-color: #5bc0de;
}

.details-btn:hover {
    background-color: #31b0d5;
}

/* Center icons and text in table-container */
.table-container span {
    margin-right: 15px;
    /* Centers the span content */
}

/* Navigation styling */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: #fff;
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
    justify-content: center;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    width: 100%;
}

.form-groupd {
    margin-bottom: 20px;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: 600;
    color: #363949;
    font-size: 16px;
}

input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ddd;
    border-radius: 5px;
    font-size: 16px;
    color: #363949;
    background-color: #fff;
    box-sizing: border-box;
    transition: border-color 0.3s ease;
}

input:focus {
    border-color: #007bff;
    outline: none;
}

.submit-btnnd {
    display: flex;
    justify-content: center;
    align-items: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s;
    margin: 10px;
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

/* Modal Styling */
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
    max-width: 600px;
    width: 90%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    overflow-y: auto;
    max-height: 90vh;
}

.modal-content h2 {
    display: flex;
    justify-content: center;
    margin: 20px;
}

.modal-content span {
    font-size: 25px;
    color: #000;
    margin-left: 10px;
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

/* Seats styling */
.seats-container {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
    justify-content: center;
}

.seat {
    width: 50px;
    height: 50px;
    background-color: #007bff;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    font-size: 1rem;
    transition: transform 0.2s, box-shadow 0.2s;
}

.seat:hover {
    transform: scale(1.1);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.seat.occupied {
    background-color: #d9534f;
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .containerd {
        padding: 10px;
    }

    .navd {
        flex-direction: column;
    }

    .nav-btnd {
        width: 100%;
        margin: 5px 0;
    }

    .form-containerd {
        width: 90%;
        padding: 15px;
    }

    .modal-content {
        width: 90%;
    }

    .seats-container {
        grid-template-columns: repeat(2, 1fr);
        gap: 5px;
    }

    .seat {
        width: 40px;
        height: 40px;
        font-size: 0.9rem;
    }
}

@media screen and (max-width: 480px) {
    .seats-container {
        grid-template-columns: 1fr;
    }

    .seat {
        width: 100%;
        height: 50px;
        font-size: 1rem;
    }
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
    padding: 2px 6px;
    border: none;
    margin: 10px;
    border-radius: 3px;
    cursor: pointer;
    transition: background-color 0.3s;
    align-items: center;
    font-size: 11px;
    height: 30px;
    width: 30px;
}

.remove-bus-button {
    background-color: #dc3545;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0 auto;
    width: 100%;
}

.remove-bus-button:hover {
    background-color: #c82333;
}

.add-bus-button {
    margin-top: 10px;
    background-color: #28a745;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0 auto;
    width: 100%;
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

/* Details Section Styling */
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

/* Responsive Design */
@media screen and (max-width: 768px) {
    .containerd {
        padding: 10px;
    }

    .navd {
        flex-direction: column;
    }

    .nav-btnd {
        width: 100%;
        margin: 5px 0;
    }

    .form-containerd {
        width: 90%;
        padding: 15px;
    }

    .modal-content {
        width: 90%;
    }
}
</style>
