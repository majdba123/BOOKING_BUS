<template>
    <div class="main-content">
        <NavBarUser />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Private Status</p>
                </div>
                <div>
                    <label class="xx" for="stateFilter">Filter by State:</label>
                    <select v-model="selectedStatus">
                        <option value="padding">pending</option>
                        <option value="complated">complated</option>
                    </select>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>From</th>
                            <th>to</th>
                            <th>Start Time</th>
                            <th>Date</th>

                            <!-- New column for state -->
                            <th>State</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(bus, index) in bus" :key="index">
                            <td v-if="selectedStatus === 'padding'">
                                {{ bus.id }}
                            </td>
                            <td v-if="selectedStatus === 'padding'">
                                {{ bus.from }}
                            </td>
                            <td v-if="selectedStatus === 'padding'">
                                {{ bus.to }}
                            </td>
                            <td v-if="selectedStatus === 'padding'">
                                {{ bus.start_time }}
                            </td>
                            <td v-if="selectedStatus === 'padding'">
                                {{ bus.date }}
                            </td>
                            <td v-if="selectedStatus === 'padding'">
                                {{ bus.status }}
                            </td>
                        </tr>
                        <tr v-for="(bus, index) in bus1" :key="index">
                            <td v-if="selectedStatus === 'complated'">
                                {{ bus.number_bus }}
                            </td>
                            <td v-if="selectedStatus === 'complated'">
                                {{ bus.number_passenger }}
                            </td>
                            <td v-if="selectedStatus === 'complated'">
                                {{ bus.status }}
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
import NavBarUser from "@/components/NavBarUser.vue";
import axios from "axios";

export default {
    name: "BusStatus",
    components: { NavBarUser },
    data() {
        return {
            editingIndex: null,
            selectedState: "",
            selectedStatus: "",
            filteredPaths: [],
            bus: [],
            bus1: [],
        };
    },
    mounted() {
        this.fetchpending();
        this.fetchcomplated();
    },
    methods: {
        fetchpending() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/user/get_my_private_order_by_status?status=padding",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.bus = response.data;
                })
                .catch(function () {});
        },
        fetchcomplated() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/user/get_my_private_order_by_status?status=complated",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.bus1 = response.data;
                })
                .catch(function () {});
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
