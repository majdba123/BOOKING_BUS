<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showForm = true">
                Add Driver
            </button>
            <button class="nav-btnd" @click="showForm = false">
                Edit Driver
            </button>
            <button class="nav-btnd" @click="showDriverStatusModal = true">
                Driver Status
            </button>
            <button class="nav-btnd" @click="fetchAllDriverWithBus">
                Drivers with Bus
            </button>
        </header>

        <!-- Form to add/edit driver -->
        <div v-if="showForm" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-row">
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
                        <label for="driverEmail">Email</label>
                        <input
                            type="email"
                            id="driverEmail"
                            v-model="email"
                            required
                        />
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-groupd">
                        <label for="driverHeight">Wages</label>
                        <input
                            type="number"
                            id="driverHeight"
                            v-model="wages"
                            required
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="driverPassword">Password</label>
                        <input
                            type="password"
                            id="driverPassword"
                            v-model="password"
                            required
                        />
                    </div>
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="CreateDriver"
                        class="submit-btnd"
                    >
                        ADD
                    </button>
                </div>
            </form>
        </div>

        <!-- Table of all drivers -->
        <div v-else class="recent_orders">
            <h1>All Drivers</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!paginatedDrivers.length"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Wages</th>
                                    <th>Status</th>
                                    <th>Select Driver To Bus</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(user, index) in filteredDrivers"
                                    :key="index"
                                >
                                    <td>{{ index + 1 }}</td>
                                    <td>{{ user.name }}</td>
                                    <td>{{ user.email_driver }}</td>
                                    <td>{{ user.Wages }}</td>
                                    <td>{{ user.status }}</td>
                                    <td>
                                        <select
                                            v-if="user.status == 'pending'"
                                            :value="user.selectedBusId || ''"
                                            @change="
                                                SelectDriver(
                                                    $event,
                                                    user.driver_id
                                                )
                                            "
                                        >
                                            <option value="">
                                                Select a bus
                                            </option>
                                            <option
                                                v-for="(bus, index) in Bus"
                                                :key="index"
                                                :value="bus.id"
                                            >
                                                {{ bus.number_bus }} Status:{{
                                                    bus.status
                                                }}
                                            </option>
                                        </select>
                                    </td>
                                    <td>
                                        <button
                                            class="delete-btn"
                                            @click="
                                                showDeleteConfirmation(
                                                    user.driver_id
                                                )
                                            "
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>

                                        <button
                                            class="cancel-btn"
                                            @click="
                                                CancelDriver(user.driver_id)
                                            "
                                        >
                                            <span class="material-icons"
                                                >close_small</span
                                            >
                                        </button>
                                        <button
                                            class="edit-btn"
                                            @click="openEditModal(user, index)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- Pagination Controls -->
                        <div class="pagination">
                            <button
                                @click="prevPage('driver')"
                                :disabled="currentPage === 1"
                            >
                                <span class="material-icons"
                                    >skip_previous</span
                                >
                            </button>
                            <span
                                >Page {{ currentPage }} of
                                {{ totalPages }}</span
                            >
                            <button
                                @click="nextPage('driver')"
                                :disabled="currentPage === totalPages"
                            >
                                <span class="material-icons">skip_next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Driver Status -->
        <div v-if="showDriverStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Driver Status</div>
                <div class="modal-body">
                    <button
                        class="status-btn"
                        @click="fetchDriverStatus('pending')"
                    >
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchDriverStatus('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchDriverStatus('Completed')"
                    >
                        Completed
                    </button>
                    <div v-if="loading1" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!paginatedDriverStatusData.length"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            driver, index
                                        ) in paginatedDriverStatusData"
                                        :key="index"
                                    >
                                        <td>{{ index + 1 }}</td>
                                        <td>{{ driver.name }}</td>
                                        <td>{{ driver.email_driver }}</td>
                                        <td>{{ driver.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeDriverStatusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Modal for Drivers with Bus -->
        <div v-if="showDriverWithBusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All Drivers with Bus</div>
                <div class="modal-body">
                    <div v-if="loading2" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!paginatedDriverWithBusData.length"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Bus ID</th>
                                        <th>Company Name</th>
                                        <th>Bus Plate Number</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            driver, index
                                        ) in paginatedDriverWithBusData"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ driver.driver_name }}</td>
                                        <td>{{ driver.bus_id }}</td>
                                        <td>{{ driver.company_name }}</td>
                                        <td>{{ driver.bus_plate_number }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button
                        @click="closeDriverWithBusModal"
                        class="close-modal"
                    >
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div v-if="showDeleteConfirmModal" class="dialog-container">
            <div class="dialog-box">
                <div class="dialog-header">Confirm Delete</div>
                <div class="dialog-body">
                    Are you sure about the deletion process?
                </div>
                <div class="dialog-footer">
                    <button @click="confirmDeleteDriver" class="confirm-btn">
                        Yes
                    </button>
                    <button
                        @click="closeDeleteConfirmModal"
                        class="close-modal"
                    >
                        No
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showEditModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Driver</div>
                <div class="modal-body">
                    <div class="form-groupd">
                        <label for="numberBus">Driver Name</label>
                        <input
                            type="text"
                            id="purshasedate"
                            v-model="editedDriver.name"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Driver Email</label>
                        <input
                            type="text"
                            id="purshaseprice"
                            v-model="editedDriver.email"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Driver Wages</label>
                        <input
                            type="number"
                            id="lifespanyears"
                            v-model="editedDriver.Wages"
                        />
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="UpdateDriver" class="update-btn">
                        Save
                    </button>
                    <button @click="closeEditModal" class="close-modal">
                        Close
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
    name: "AddDriver",
    data() {
        return {
            memoryUsed: null,
            frameRate: 0,
            lastTimestamp: 0,
            frameCount: 0,
            measuring: false,
            intervalId: null,
            data: null,
            wages: "",
            loading: true,
            loading1: false,
            loading2: true,
            showForm: true,
            Driver: [],
            Bus: [],
            driverStatusData: [],
            driverWithBusData: [],
            showEditModal: false,
            editedDriver: {
                driver_id: "",
                name: "",
                email: "",
                Wages: "",
            },
            editingIndex: null,

            name: "",
            email: "",
            password: "",
            showDriverStatusModal: false,
            showDriverWithBusModal: false,
            toast: useToast(),
            isDarkMode: false,
            showDeleteConfirmModal: false,
            driverIdToDelete: null,
            currentPage: 1,
            itemsPerPage: 8,

            currentPageStatus: 1,
            currentPageBus: 1,
        };
    },
    mounted() {
        // this.fetch();
        this.AllDriver();
        this.fetchBus();
        this.isDarkMode = localStorage.getItem("theme") === "dark";
        if (this.isDarkMode) {
            document.body.classList.add("dark-theme-variables");
        }
    },
    methods: {
        closeEditModal() {
            this.showEditModal = false;
        },
        closeDriverStatusModal() {
            this.showDriverStatusModal = false;
        },
        closeDriverWithBusModal() {
            this.showDriverWithBusModal = false;
        },
        handleSubmit() {},
        showDeleteConfirmation(driverId) {
            this.driverIdToDelete = driverId;
            this.showDeleteConfirmModal = true;
        },
        confirmDeleteDriver() {
            this.DeleteDriver(this.driverIdToDelete);
            this.showDeleteConfirmModal = false;
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
        },
        UpdateDriver() {
            const access_token = window.localStorage.getItem("access_token");
            const busId = this.editedDriver.driver_id;

            axios
                .put(
                    `http://127.0.0.1:8000/api/company/update_driver/${busId}`,
                    {
                        name: this.editedDriver.name,
                        email: this.editedDriver.email,
                        Wages: this.editedDriver.Wages,
                    },
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then(() => {
                    this.editingIndex = null;

                    this.editedDriver = {
                        id: "",
                        name: "",
                        email: "",
                        wages: "",
                    };

                    this.toast.success("Driver updated successfully!");
                    this.showEditModal = false;
                })
                .catch(() => {
                    // console.log(this.editedDriver);

                    this.toast.error("Error updating Driver.");
                });
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
                    Wages: this.wages,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status == 200) {
                        this.toast.success(
                            "Driver account created successfully!"
                        );
                        this.AllDriver();
                    }
                })
                .catch((error) => {
                    if (this.wages.length == 0)
                        this.toast.error(error.response.data.error.Wages[0]);
                    if (this.name.length == 0)
                        this.toast.error(error.response.data.error.name[0]);

                    if (this.email.length == 0)
                        this.toast.error(error.response.data.error.email[0]);

                    if (this.password.length <= 8)
                        this.toast.error(error.response.data.error.password[0]);
                    this.toast.error(error.response.data.error.email[0]);
                });
        },
        openEditModal(bus, index) {
            this.editedDriver = { ...bus };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        CancelDriver(driverId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/cancelled_driver/${driverId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Driver cancelled successfully!");
                    this.AllDriver();
                })
                .catch((error) => {
                    this.toast.error(error.response.data.error);
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
                    store.state.Driver = response.data.sort((a, b) => {
                        if (a.name < b.name) return -1;
                        if (a.name > b.name) return 1;
                        return 0;
                    });

                    this.Driver = response.data.sort((a, b) => {
                        if (a.name < b.name) return -1;
                        if (a.name > b.name) return 1;
                        return 0;
                    });
                    this.loading = false;
                })
                .catch(() => {
                    this.toast.error("Error getting drivers.");
                });
            this.loading = true;
        },

        DeleteDriver(driverId) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_driver/${driverId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Driver deleted successfully!");
                    this.AllDriver();
                })
                .catch(() => {
                    this.toast.error("Error deleting driver.");
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
                })
                .catch(() => {
                    this.toast.error("Error getting buses.");
                });
        },
        SelectDriver(event, userId) {
            const busId = event.target.value;
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/select_driver_to_bus/${busId}`,
                data: { driver_id: userId },
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    this.toast.success("Driver assigned to bus successfully!");
                })
                .catch((error) => {
                    this.toast.error(error.response.data.error);
                });
        },

        fetchDriverStatus(status) {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/get_driver_by_status?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverStatusData = response.data;
                    this.loading1 = false;
                })
                .catch(() => {
                    window.alert("Error fetching driver status");
                });
            this.loading1 = true;
        },
        fetchAllDriverWithBus() {
            this.showDriverWithBusModal = true;
            this.loading2 = true;
            const memoryBefore = performance.memory.usedJSHeapSize;

            const access_token = window.localStorage.getItem("access_token");
            // const startTime = performance.now(); // بدء قياس الوقت

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_driver_with_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverWithBusData = response.data;
                    this.loading2 = false;

                    // const endTime = performance.now();
                    // const duration = (endTime - startTime).toFixed(2);

                    // console.log("Fetch Time:", duration / 1000, "S");
                    // console.log(
                    //     "Frames during fetch:",
                    //     Math.round(duration / (1000 / 60))
                    // );
                    const memoryAfter = performance.memory.usedJSHeapSize;
                    this.memoryUsed = (
                        (memoryAfter - memoryBefore) /
                        1024 /
                        1024
                    ).toFixed(2);
                    // console.log("Memory Usage:", this.memoryUsed, "MB");
                })
                .catch(() => {
                    window.alert("Error fetching drivers with bus.");
                    this.loading2 = false;
                });
        },

        // fetch() {
        //     this.loading2 = true;
        //     const memoryBefore = performance.memory.usedJSHeapSize;

        //     const access_token = window.localStorage.getItem("access_token");
        //     const startTime = performance.now(); // بدء قياس الوقت

        //     axios({
        //         method: "get",
        //         url: "http://127.0.0.1:8000/api/company/all_driver_with_bus",
        //         headers: { Authorization: `Bearer ${access_token}` },
        //     })
        //         .then((response) => {
        //             this.driverWithBusData = response.data;
        //             this.loading2 = false;

        //             const endTime = performance.now();
        //             const duration = (endTime - startTime).toFixed(2);

        //             console.log("Fetch Time:", duration / 1000, "ms"); // عرض الوقت المستغرق
        //             console.log(
        //                 "Frames during fetch:",
        //                 Math.round(duration / (1000 / 60))
        //             );
        //             const memoryAfter = performance.memory.usedJSHeapSize;
        //             this.memoryUsed = (
        //                 (memoryAfter - memoryBefore) /
        //                 1024 /
        //                 1024
        //             ).toFixed(2);
        //             console.log("Memory Usage:", this.memoryUsed, "MB");
        //         })
        //         .catch((error) => {
        //             window.alert("Error fetching drivers with bus.");
        //             console.error(error);
        //             this.loading2 = false;
        //         });
        // },
        toggleTheme() {
            this.isDarkMode = !this.isDarkMode;
            document.body.classList.toggle(
                "dark-theme-variables",
                this.isDarkMode
            );
            localStorage.setItem("theme", this.isDarkMode ? "dark" : "light");
        },
        prevPage(type) {
            if (type === "driver" && this.currentPage > 1) {
                this.currentPage--;
            } else if (type === "status" && this.currentPageStatus > 1) {
                this.currentPageStatus--;
            } else if (type === "bus" && this.currentPageBus > 1) {
                this.currentPageBus--;
            }
            this.updateFilteredData(type);
        },
        nextPage(type) {
            if (type === "driver" && this.currentPage < this.totalPages) {
                this.currentPage++;
            } else if (
                type === "status" &&
                this.currentPageStatus < this.totalPagesStatus
            ) {
                this.currentPageStatus++;
            } else if (
                type === "bus" &&
                this.currentPageBus < this.totalPagesBus
            ) {
                this.currentPageBus++;
            }
            this.updateFilteredData(type);
        },
        goToPage(pageNumber, type) {
            if (
                type === "driver" &&
                pageNumber >= 1 &&
                pageNumber <= this.totalPages
            ) {
                this.currentPage = pageNumber;
            } else if (
                type === "status" &&
                pageNumber >= 1 &&
                pageNumber <= this.totalPagesStatus
            ) {
                this.currentPageStatus = pageNumber;
            } else if (
                type === "bus" &&
                pageNumber >= 1 &&
                pageNumber <= this.totalPagesBus
            ) {
                this.currentPageBus = pageNumber;
            }
            this.updateFilteredData(type);
        },
        updateFilteredData(type) {
            if (type === "driver") {
                this.filteredDrivers = this.paginatedDrivers;
            } else if (type === "status") {
                this.filteredDriverStatusData = this.paginatedDriverStatusData;
            } else if (type === "bus") {
                this.filteredDriverWithBusData =
                    this.paginatedDriverWithBusData;
            }
        },
    },
    computed: {
        filteredDrivers() {
            return store.state.Driver.filter((driver) => {
                return (
                    driver.name
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.email_driver
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase()) ||
                    driver.status
                        .toLowerCase()
                        .includes(store.state.searchQuery.toLowerCase())
                );
            });
        },
        paginatedDrivers() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return store.state.Driver.slice(start, end);
        },
        totalPages() {
            return Math.ceil(this.Driver.length / this.itemsPerPage);
        },
        paginatedDriverStatusData() {
            const start = (this.currentPageStatus - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.driverStatusData.slice(start, end);
        },
        totalPagesStatus() {
            return Math.ceil(this.driverStatusData.length / this.itemsPerPage);
        },
        paginatedDriverWithBusData() {
            const start = (this.currentPageBus - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.driverWithBusData.slice(start, end);
        },
        totalPagesBus() {
            return Math.ceil(this.driverWithBusData.length / this.itemsPerPage);
        },
    },
};
</script>

<style scoped>
.form-row {
    display: flex;
    justify-content: space-between;
    gap: 20px; /* المسافة بين كل عنصرين */
}

.form-groupd {
    flex: 1; /* لتوزيع المساحة بالتساوي بين الحقول */
}

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
    }
}

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
    --clr-primary: #bb86fc;
    --clr-danger: #cf6679;
    --clr-success: #03dac6;
    --clr-white: #121212;
    --clr-info-dark: #bb86fc;
    --clr-info-light: #292929;
    --clr-dark: #f6f6f9;
    --clr-warning: #ffbb55;
    --clr-light: rgba(255, 255, 255, 0.2);
    --clr-primary-variant: #3700b3;
    --clr-dark-variant: #1f1f1f;
    --clr-color-background: #121212;
}
h1 {
    font-size: 1.2rem;
    color: var(--clr-dark);
    margin-bottom: 5px;
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
    background: var(--clr-color-background);
}
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    font-size: 1.2rem;
    color: var(--clr-dark);
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background: var(--clr-white);
}
.dialog-container {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}

.dialog-box {
    background: var(--clr-white);
    color: var(--clr-dark);
    padding: 15px;
    border-radius: 10px;
    max-width: 400px;
    width: 50%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    text-align: center;
}

.dialog-header,
.dialog-body,
.dialog-footer {
    margin-bottom: 15px;
}

.dialog-header {
    font-size: 1.3rem;
    font-weight: bold;
    text-align: center;
}

.dialog-body {
    text-align: center;
}

.dialog-footer {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.confirm-btn {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.confirm-btn:hover {
    background-color: #4cae4c;
}

.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.recent_orders h1 {
    margin: 18px;
    color: var(--clr-dark);
}

.recent_orders {
    width: 100%;
    margin-top: 20px;
}

.table-container {
    width: 100%;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1rem 1.5rem rgba(132, 139, 200, 0.18);
    color: var(--clr-dark);
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
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
    transition: background-color 0.3s ease;
}

table tbody tr:hover {
    background-color: var(--clr-light);
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
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
    padding: 8px;
    border: 1px solid var(--clr-primary);
    border-radius: 4px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    font-size: 0.85rem;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: var(--clr-primary);
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}
.spinner {
    border: 4px solid var(--clr-light);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh;
}

/* Add this part for the spinner rotation */
@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}
.edit-btn {
    color: #4caf50;
    background-color: var(--clr-white);
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}
.edit-btn:hover {
    color: var(--clr-white);
    background-color: var(--clr-success);
}
.edit-btn.material-icons,
.delete-btn.material-icons,
.status-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 8px;
    border-radius: 9px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 15px;
    width: 15px;
}
/* Add this part for the spinner rotation */
@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}
/* Delete button styling */

.delete-btn.material-icons,
.cancel-btn.material-icons {
    padding: 0;
    border: none;
    margin: 5px;
    border-radius: 50%;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 20px;
    width: 20px;
}

.cancel-btn {
    border-radius: 9px;
    width: 29px;
    padding: 2px;
    margin: 5px;
    color: #f44336;
    background-color: var(--clr-white);
}
.cancel-btn:hover {
    color: #fff;
    background-color: #f44336;
}
.delete-btn {
    color: #f44336;
    border-radius: 9px;
    padding: 3px;
    background-color: var(--clr-white);
}

.update-btn {
    padding: 8px 16px;
    background-color: var(--clr-success);
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-right: 10px;
}

.update-btn:hover {
    background-color: #4cae4c;
}
.delete-btn:hover {
    color: #fff;
    background-color: #f44336;
}
/* Navigation styling */

.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: var(--clr-white);
    border-radius: 10px;
    width: 100%;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 15px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
    width: 100%;
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

/* Form styling */
.form-containerd {
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 20px;
    background-color: var(--clr-white);
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    border-radius: 10px;
    width: 100%;
}

.form-groupd {
    margin-bottom: 15px;
    width: 100%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: var(--clr-dark);
}

input {
    width: 100%;
    padding: 15px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    font-size: 18px;
    box-sizing: border-box;
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
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s, transform 0.2s;
}

.submit-btnd:hover {
    background-color: var(--clr-primary-variant);
    transform: translateY(-3px);
}

/* Modal styling */

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
    background-color: var(--clr-color-background);
    padding: 20px;
    border-radius: var(--border-radius-2);
    max-width: 90%;
    width: 90%;
    height: auto;
    max-height: 80%;
    box-shadow: var(--box-shadow);
    overflow: auto;
}

.modal-header,
.modal-body div,
.modal-footer {
    margin-bottom: 15px;
}

.modal-header {
    color: var(--clr-dark);
    font-size: 1.5rem;
    font-weight: bold;
    text-align: center;
    padding-bottom: 10px;
    border-bottom: 2px solid var(--clr-primary);
}

.modal-body div div {
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal-body div table {
    width: 100%;
    border-collapse: collapse;
}

.modal-body div th,
.modal-body div td {
    padding: 12px;
    text-align: left;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
}

.modal-body table thead {
    border-bottom: 2px solid var(--clr-dark);
}

.modal-body table tr th:first-child,
.modal-body table tr td:first-child {
    border-left: 1px solid var(--clr-dark);
}

.modal-body table tr th:last-child,
.modal-body table tr td:last-child {
    border-right: 1px solid var(--clr-dark);
}

.modal-body table th,
.modal-body table td {
    height: 100%;
}

.modal-body table td:first-child {
    border-left: 1px solid var(--clr-dark);
}

.modal-body table td:last-child {
    border-right: 1px solid var(--clr-dark);
}

.modal-body table th:first-child {
    border-left: 1px solid var(--clr-dark);
}

.modal-body table th:last-child {
    border-right: 1px solid var(--clr-dark);
}
.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.close-modal:hover {
    background-color: #c9302c;
}

.status-btn {
    padding: 8px 16px;
    margin: 5px;
    border-radius: 4px;
    cursor: pointer;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    transition: background-color 0.3s;
}

.status-btn:hover {
    background-color: var(--clr-primary-variant);
}
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
}

.pagination button {
    padding: 6px 10px;
    margin: 0 5px;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s;
}

.pagination button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
}

.pagination span {
    margin: 0 10px;
    font-size: 0.7rem;
    color: var(--clr-dark);
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .container {
        width: 100%;
    }

    .recent_orders {
        padding: 30px;
        margin: 0 auto;
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
        background-color: var(--clr-primary);
        color: var(--clr-white);
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
    background: var(--clr-color-background);
}
@media screen and (max-width: 480px) {
    .navd {
        align-items: center;
    }

    .nav-btnd {
        padding: 8px 10px;
        font-size: 12px;
    }

    .form-containerd {
        width: 100%;
        padding: 10px;
    }

    .recent_orders h1 {
        font-size: 1rem;
        text-align: center;
    }

    .recent_orders table {
        font-size: 0.75rem;
    }

    select {
        padding: 6px;
        font-size: 0.75rem;
    }

    .delete-btn,
    .cancel-btn {
        height: 16px;
        width: 16px;
        font-size: 12px;
    }

    .modal-content {
        width: 90%;
        padding: 15px;
    }

    .modal-header {
        font-size: 1rem;
    }
}
@media screen and (max-width: 360px) {
    .nav-btnd {
        padding: 6px 8px;
        font-size: 10px;
    }

    .recent_orders h1 {
        font-size: 0.9rem;
    }

    .modal-content {
        padding: 10px;
    }

    .modal-body table {
        font-size: 0.7rem;
    }
}
</style>
