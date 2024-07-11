@ -1,141 +0,0 @@
<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Driver Active</p>
                </div>

                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>

                            <th>Driver Name</th>
                            <!-- New column for state -->
                            <th>Bus ID</th>
                            <th>Company Name</th>
                            <th>Bus Plate Number</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(driver, index) in Driver" :key="index">
                            <td>{{ driver.id }}</td>
                            <td>{{ driver.driver_name }}</td>
                            <td>{{ driver.bus_id }}</td>
                            <td>{{ driver.company_name }}</td>
                            <td>{{ driver.bus_plate_number }}</td>
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
    name: "DriverActive",
    components: { NavBarCompany },
    data() {
        return {
            Driver: [],
        };
    },
    mounted() {
        this.AllDriver();
    },

    methods: {
        CancelDriver(x) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/cancelled_driver/" + x,

                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Cancel Complate");

                    window.location.reload();
                })
                .catch(function (error) {
                    window.alert("Error Cancel Driver");
                    console.error(x);
                    console.error(error);
                });
        },
        AllDriver() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver_with_bus",
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
