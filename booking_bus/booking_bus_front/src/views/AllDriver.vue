<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>All Driver</p>
                </div>

                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Select Driver To Bus</th>

                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(user, index) in Driver" :key="index">
                            <td>
                                {{ user.id }}
                            </td>
                            <td>
                                {{ user.user.name }}
                            </td>
                            <td>
                                {{ user.user.email }}
                            </td>
                            <td>
                                {{ user.status }}
                            </td>
                            <td>
                                <select @change="SelectDriver($event, user.id)">
                                    <option
                                        v-for="(bus, index) in Bus"
                                        :key="index"
                                        :value="bus.id"
                                    >
                                        {{ bus.number_bus }}
                                    </option>
                                </select>
                            </td>
                            <td>
                                <button @click="DeleteDriver(user.id)">
                                    Delete
                                </button>
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
    name: "AllDriver",
    components: { NavBarCompany },
    data() {
        return {
            editingIndex: null,
            Driver: [],
            Bus: [],
        };
    },
    mounted() {
        this.AllDriver();
        this.fetchBus();
    },
    methods: {
        AllDriver() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Driver = response.data;
                    console.log(this.Driver);
                })
                .catch(function (error) {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
        DeleteDriver(x) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "delete",
                url: "http://127.0.0.1:8000/api/company/delete_driver/" + x,

                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Deleted Complate");

                    window.location.reload();
                })
                .catch(function (error) {
                    window.alert("Error get Driver");
                    console.error(x);
                    console.error(error);
                });
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
                    console.log(this.Bus);
                })
                .catch(function (error) {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
        SelectDriver(event, userId) {
            const busId = event.target.value;
            const access_token = window.localStorage.getItem("access_token");
            console.log("Selected Bus ID:", busId);

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/select_driver_to_bus/${busId}`,
                data: {
                    driver_id: userId,
                },
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    console.log("Selection Complete for Bus ID:", busId);
                    window.alert("Selected Complete");
                    window.location.reload();
                })
                .catch(function (error) {
                    console.log(busId);

                    window.alert("Error getting Bus");
                    console.error("Error for Bus ID:", busId, error);
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
