<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Driver Status</p>
                </div>
                <div>
                    <label class="xx" for="stateFilter">Filter by State:</label>
                    <select v-model="selectedStatus">
                        <option value="pending">pending</option>
                        <option value="available">available</option>
                        <option value="finished">finished</option>
                    </select>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Driver Name</th>
                            <!-- New column for state -->
                            <th>State</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(bus, index) in bus" :key="index">
                            <td v-if="selectedStatus === 'pending'">
                                {{ bus.number_bus }}
                            </td>
                            <td v-if="selectedStatus === 'pending'">
                                {{ bus.number_passenger }}
                            </td>
                            <td v-if="selectedStatus === 'pending'">
                                {{ bus.status }}
                            </td>
                        </tr>
                        <tr v-for="(bus1, index) in bus1" :key="index">
                            <td v-if="selectedStatus === 'available'">
                                {{ bus1.number_bus }}
                            </td>
                            <td v-if="selectedStatus === 'available'">
                                {{ bus1.number_passenger }}
                            </td>
                            <td v-if="selectedStatus === 'available'">
                                {{ bus1.status }}
                            </td>
                        </tr>
                        <tr v-for="(bus2, index) in bus2" :key="index">
                            <td v-if="selectedStatus === 'finished'">
                                {{ bus2.number_bus }}
                            </td>
                            <td v-if="selectedStatus === 'finished'">
                                {{ bus2.number_passenger }}
                            </td>
                            <td v-if="selectedStatus === 'finished'">
                                {{ bus2.status }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- Existing code for editing form -->
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";
import axios from "axios";

export default {
    name: "DriverStatus",
    components: { NavBarCompany },
    data() {
        return {
            editingIndex: null,
            selectedState: "",
            selectedStatus: "",
            filteredPaths: [],
            bus: [],
            bus1: [],
            bus2: [],
            Bus: [],
        };
    },
    mounted() {
        this.fetchpending();
        this.fetchavailable();
        this.fetchfinished();
    },
    fetchBus() {
        const access_token = window.localStorage.getItem("access_token");

        axios({
            method: "get",
            url: "http://127.0.0.1:8000/api/company/all_bus",
            headers: { Authorization: `Bearer ${access_token}` },
        })
            .then((response) => {
                this.Bus = response.data;
                console.log(this.path);
            })
            .catch(function (error) {
                window.alert("Error get paths");
                console.error(error);
            });
    },
    methods: {
        fetchpending() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/get_driver_by_status?status=pending",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    console.log(response);
                    this.bus = response.data;
                })
                .catch(function (error) {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
        fetchavailable() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/get_driver_by_status?status=available",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    console.log(response);
                    this.bus1 = response.data;
                })
                .catch(function (error) {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
        fetchfinished() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/get_driver_by_status?status=finished",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.bus2 = response.data;

                    console.log(response);
                })
                .catch(function (error) {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
    },
};
</script>
<style scoped>
/* تنسيقات عامة */
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
.xx {
    color: #176b87;
}
/* تنسيق العنوان */
.title p {
    padding: 15px;
    background-color: #176b87;
    border-radius: 15px;
    text-align: center;
    font-size: 26px;
    color: white;
}

/* تنسيق الجدول */
.table {
    border-collapse: collapse;
    width: 100%;
    margin: 11px auto;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* إضافة ظل للجدول */
}
.table thead tr {
    background: #176b87;
    color: white;
}
.table th,
.table td {
    padding: 12px 15px;
    border-bottom: 1px solid #176b87; /* إضافة حد فاصل */
}
.table tr td {
    color: #176b87;
}

/* تنسيق عنصر select */
#stateFilter {
    padding: 10px;
    margin-bottom: 20px;
    border-radius: 4px;
    border: 1px solid #176b87;
    background-color: white;
}

/* تنسيق الأزرار */
button {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    border: 1px solid #176b87; /* إضافة حد للزر */
}
button:hover {
    background-color: #144f63;
    color: white;
}
</style>
