<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Trip Status</p>
                </div>
                <div>
                    <label class="xx" for="stateFilter">Filter by State:</label>
                    <select
                        v-model="selectedStatus"
                        @change="fetchTripsByStatus"
                        class="colorselect"
                    >
                        <option value="padding">pending</option>
                        <option value="available">available</option>
                        <option value="finished">finished</option>
                    </select>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Trip ID</th>
                            <th>Price</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(trip, index) in trips" :key="index">
                            <td v-if="selectedStatus === 'padding'">
                                {{ trip.id }}
                            </td>

                            <td v-if="selectedStatus === 'padding'">
                                {{ trip.price }}
                            </td>
                            <td v-if="selectedStatus === 'padding'">
                                {{ trip.status }}
                            </td>
                        </tr>
                        <tr v-for="(trip1, index) in trip1" :key="index">
                            <td v-if="selectedStatus === 'available'">
                                {{ trip1.id }}
                            </td>

                            <td v-if="selectedStatus === 'available'">
                                {{ trip1.price }}
                            </td>
                            <td v-if="selectedStatus === 'available'">
                                {{ trip1.status }}
                            </td>
                        </tr>
                        <tr v-for="(trip2, index) in trip2" :key="index">
                            <td v-if="selectedStatus === 'finished'">
                                {{ trip2.id }}
                            </td>

                            <td v-if="selectedStatus === 'finished'">
                                {{ trip2.price }}
                            </td>
                            <td v-if="selectedStatus === 'finished'">
                                {{ trip2.status }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";
import axios from "axios";

export default {
    name: "TripStatus",
    components: { NavBarCompany },
    data() {
        return {
            trips: [],
            editingIndex: null,
            selectedState: "",
            selectedStatus: "",
            filteredPaths: [],
            trips1: [],
            trips2: [],
        };
    },
    mounted() {
        this.fetchTripsByStatus();
        this.fetchTripsByStatus1();
        this.fetchTripsByStatus2();
    },
    methods: {
        fetchTripsByStatus() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_trips_by_status?status=padding`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.trips = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching trips");
                    console.error(error);
                });
        },
        fetchTripsByStatus1() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_trips_by_status?status=available`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.trips1 = response.data;
                })
                .catch((error) => {
                    window.alert("Error fetching trips");
                    console.error(error);
                });
        },
        fetchTripsByStatus2() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_trips_by_status?status=finished`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.trips2 = response.data;
                })
                .catch((error) => {
                    window.alert("Error fetching trips");
                    console.error(error);
                });
        },
    },
};
</script>

<style scoped>
* {
    font-family: "Poppins", sans-serif;
}
.main-content {
    display: flex;
    width: 100%;
}
.content {
    flex-grow: 1;
}
.continer {
    width: 90%;
    margin: 20px auto;
    text-align: center;
}
.colorselect option {
    color: black;
}
.colorselect {
    color: black;
}
.xx {
    color: #176b87;
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
    margin: 11px auto;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
.table thead tr {
    background: #176b87;
    color: white;
}
.table th,
.table td {
    padding: 12px 15px;
    border-bottom: 1px solid #176b87;
}
.table tr td {
    color: #176b87;
}

#stateFilter {
    padding: 10px;
    margin-bottom: 20px;
    border-radius: 4px;
    border: 1px solid #176b87;
    background-color: white;
}

button {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    border: 1px solid #176b87;
}
button:hover {
    background-color: #144f63;
    color: white;
}
</style>
