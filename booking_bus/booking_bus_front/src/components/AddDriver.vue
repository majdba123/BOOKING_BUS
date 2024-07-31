<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">
                Add Driver
            </button>
            <button class="nav-btnd" @click="showForm = false">
                Edit Driver
            </button>
            <button class="nav-btnd">Button 3</button>
            <button class="nav-btnd">Button 4</button>
        </header>

        <div v-if="showForm" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="driverName">Driver Name</label>
                    <input
                        type="text"
                        id="driverName"
                        v-model="name"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverAge">Email</label>
                    <input
                        type="text"
                        id="driverAge"
                        v-model="email"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverLicense">Password</label>
                    <input
                        type="text"
                        id="driverLicense"
                        required
                        v-model="password"
                    />
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="CreateDriver"
                        class="submit-btnd"
                    >
                        Submit
                    </button>
                </div>
            </form>
        </div>

        <div v-else class="recent_orders">
            <h1>All Driver</h1>
            <div class="table-container">
                <table>
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
                        <tr
                            v-for="(user, index) in filteredDrivers"
                            :key="index"
                        >
                            <td>{{ user.driver_id }}</td>
                            <td>{{ user.name }}</td>
                            <td>{{ user.email_driver }}</td>
                            <td>{{ user.status }}</td>
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
                                <button
                                    class="delete-btn"
                                    @click="DeleteDriver(user.id)"
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
</template>

<script>
import axios from "axios";
import store from "@/store";

export default {
    name: "AddDriver",
    data() {
        return {
            showForm: true,
            Driver: [],
            Bus: [],
            name: "",
            email: "",
            password: "",
        };
    },
    mounted() {
        this.AllDriver();
        this.fetchBus();
    },
    methods: {
        handleSubmit() {
            console.log(
                "Form Submitted",
                this.driverName,
                this.driverAge,
                this.driverLicense
            );
            // Add your form submission logic here
        },
        CreateDriver() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/register/driver",
                data: {
                    name: this.name,
                    email: this.email,
                    password: this.password,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status == 200) {
                        console.log(response);
                        window.alert("تم اضافة حساب سائق");
                    }
                })
                .catch((error) => {
                    window.alert("البريد مسجل سابقا ");
                    console.log(error);
                });
        },
        AllDriver() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Driver = response.data;
                    store.state.Driver = response.data;
                    console.log(response.data);
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
                    window.alert("Deleted Complete");
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
                data: { driver_id: userId },
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
    watch: {
        filteredDriver() {
            console.log(store.state.searchQuery);
        },
    },
    computed: {
        filteredDrivers() {
            console.log(store.state.Driver);
            return store.state.Driver.filter((driver) => {
                return (
                    driver.name
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.email_driver
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase())
                );
            });
        },
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
.dark-theme-variables {
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --box-shadow: 0 2rem 3rem var(--clr-light);
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
    user-select: none;
    background: #f6f6f9;
}

a {
    color: #363949;
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
}

h2 {
    font-size: 1.4rem;
}

h3 {
    font-size: 0.87rem;
}

h4 {
    font-size: 0.8rem;
}

h5 {
    font-size: 0.77rem;
}

small {
    font-size: 0.75rem;
}

.text-muted {
    color: #7d8da1;
}

.primary {
    color: #7380ec;
}

.success {
    color: var(--clr-success);
}

.danger {
    color: #ff7782;
}

.recent_orders h1 {
    margin: 18px;
    color: #363949;
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
    border-radius: 2rem;
    padding: 1.8rem;
    text-align: center;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
    color: #363949;
    max-width: 100%;
    margin: auto;
    min-width: 800px;
}

.recent_orders table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: 15px;
}

table tbody tr {
    height: 3.8rem;
    border-bottom: 1px solid #fff;
    color: #677483;
}

table tbody td {
    height: 3.8rem;
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
}

/* Select styling */
select {
    padding: 10px;
    border: 1px solid #7380ec;
    border-radius: 5px;
    background-color: #fff;
    color: #363949;
    font-size: 0.88rem;
    outline: none;
    transition: border-color 0.3s;
}

select:focus {
    border-color: #007bff;
}

/* Delete button styling */
.delete-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    border: 1px solid #ff7782;
    background-color: #fff;
    color: #ff7782;
}

.delete-btn:hover {
    background-color: #ff7782;
    color: #fff;
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .container {
        width: 100%;
        grid-template-columns: repeat(1, 1fr);
    }

    aside {
        position: fixed;
        width: 18rem;
        z-index: 3;
        background-color: #fff;
        display: none;
        left: -100px;
        animation: menuAni 1s forwards;
    }
    @keyframes menuAni {
        to {
            left: 0;
        }
    }

    .recent_orders {
        padding: 30px;
        margin: 0 auto;
    }
    .date {
        margin-top: 40px;
        margin-left: 44px;
    }

    .right .profile {
        position: absolute;
        left: 70%;
    }

    .right .recent_updates {
        padding: 30px;
    }

    .right .top button {
        display: inline-block;
        background: transparent;
        cursor: pointer;
        color: #363949;
        position: absolute;
        left: 1rem;
    }

    .theme-toggler {
        display: flex;
        justify-content: space-between;
        height: 1.6rem;
        width: 4.2rem;
        cursor: pointer;
        border-radius: 10px;
    }

    .theme-toggler span {
        font-size: 1.2rem;
        width: 50%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .theme-toggler span.active {
        background-color: #7380ec;
        color: #fff;
        border-radius: 10px;
    }
}

.containerd {
    width: 100%;
    margin-left: 20px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-size: cover;
    min-height: 100vh;
}

.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    width: 100%;
    max-width: 490px;
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

.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    max-width: 400px;
    width: 100%;
    margin-top: 50px;
}
.form-containerd:hover {
    box-shadow: none;
}

.form-groupd {
    margin-bottom: 15px;
    width: 100%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    background-color: rgba(255, 255, 255, 0.6);
}

input:focus {
    border-color: #007bff;
}

.submit-btnnd {
    display: flex;
    justify-content: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s;
}

.submit-btnd:hover {
    background-color: #0056b3;
}
</style>
