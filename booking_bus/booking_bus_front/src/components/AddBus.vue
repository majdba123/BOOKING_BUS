<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd" @click="showaddmodel()">Add Bus</button>
            <button class="nav-btnd" @click="showmodel()">Edit Bus</button>
            <button class="nav-btnd" @click="showBusStatusModal = true">
                Bus Status
            </button>
            <button class="nav-btnd" @click="showinsurancemodel()">
                Add Insurance
            </button>
            <button class="nav-btnd" @click="showmaintenancemodel()">
                Maintenance
            </button>
        </header>
        <div v-if="showmaintenancemodell" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="path">Bus</label>
                    <div class="select-container">
                        <select v-model="BusIDD" id="path">
                            <option
                                v-for="(pathItem, index) in Bus"
                                :key="index"
                                :value="pathItem.id"
                            >
                                {{ pathItem.number_bus }}
                            </option>
                        </select>
                    </div>
                </div>
                <div class="form-groupd">
                    <label for="numberBus">Cost</label>
                    <input
                        type="number"
                        id="numberBus"
                        v-model="cost"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberPassenger">Maintenance Date</label>
                    <input
                        type="date"
                        id="numberPassenger"
                        v-model="maintenancedate"
                        required
                    />
                </div>
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea
                        id="description"
                        v-model="description"
                        placeholder="Enter your description here"
                        class="description-input"
                    ></textarea>
                </div>

                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="Addmaintenance"
                        class="submit-btnd"
                    >
                        ADD
                    </button>
                </div>
            </form>
            <div class="table-container">
                <div v-if="loading10" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Maintenance.length" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Number Bus</th>
                                    <th>Cost</th>
                                    <th>Maintenance Date</th>
                                    <th>Description</th>

                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(bus, index) in Maintenance"
                                    :key="index"
                                >
                                    <th>{{ index }}</th>
                                    <td>{{ bus.number_bus }}</td>
                                    <td>{{ bus.cost }}</td>
                                    <td>{{ bus.maintenance_date }}</td>
                                    <td>{{ bus.description }}</td>

                                    <td>
                                        <button
                                            class="edit-btn"
                                            @click="openEditModal1(bus, index)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                        <button
                                            class="delete-btn"
                                            @click="confirmDeleteBus1(bus)"
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- Add Insurance Form -->
        <div v-if="showinsurancemodell" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="numberBus">Insurance Cost</label>
                    <input
                        type="text"
                        id="numberBus"
                        v-model="insurancecost"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberPassenger">Insurance Date</label>
                    <input
                        type="number"
                        id="numberPassenger"
                        v-model="insurancedate"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="path">Bus</label>
                    <div class="select-container">
                        <select v-model="BusIDD" id="path">
                            <option
                                v-for="(pathItem, index) in Bus"
                                :key="index"
                                :value="pathItem.id"
                            >
                                {{ pathItem.number_bus }}
                            </option>
                        </select>
                    </div>
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="AddInsurance"
                        class="submit-btnd"
                    >
                        ADD
                    </button>
                </div>
            </form>
            <div class="table-container">
                <div v-if="loading10" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!INC.length" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Number Bus</th>
                                    <th>Insurance Cost</th>
                                    <th>Insurance Date</th>
                                    <th>Delete</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(bus, index) in INC" :key="index">
                                    <th>{{ index }}</th>
                                    <td>{{ bus.number_bus }}</td>
                                    <td>{{ bus.insurance_cost }}</td>
                                    <td>{{ bus.insurance_date }}</td>

                                    <td>
                                        <button
                                            class="delete-btn"
                                            @click="confirmDeleteBus2(bus)"
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- Add Bus Form -->
        <div v-if="showaddmodell" class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="numberBus">Number Bus</label>
                    <input
                        type="text"
                        id="numberBus"
                        v-model="number_bus"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberPassenger">Number Passenger</label>
                    <input
                        type="text"
                        id="numberPassenger"
                        v-model="number_passenger"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberPassenger">Brand</label>
                    <input
                        type="text"
                        id="numberPassenger"
                        v-model="brand"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberBus">Purshase Date</label>
                    <input
                        type="date"
                        id="purshasedate"
                        v-model="purshasedate"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberBus">Purshase Price</label>
                    <input
                        type="number"
                        id="purshaseprice"
                        v-model="purshaseprice"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberBus">Lifespan Years</label>
                    <input
                        type="number"
                        id="lifespanyears"
                        v-model="lifespanyears"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberBus">Bus Consumption</label>
                    <input
                        type="number"
                        id="busconsumption"
                        v-model="busconsumption"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="numberBus">Fuel Consumption</label>
                    <input
                        type="number"
                        id="fuelconsumption"
                        v-model="fuelconsumption"
                        required
                    />
                </div>

                <div class="submit-btnnd">
                    <button type="submit" @click="AddBus" class="submit-btnd">
                        ADD
                    </button>
                </div>
            </form>
        </div>

        <!-- Bus Table -->
        <div v-if="showmodell" class="recent_orders">
            <h1>All Bus</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!paginatedBuses.length" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Number Bus</th>
                                    <th>Number Passenger</th>
                                    <th>Brand</th>

                                    <th>Purshase Date</th>
                                    <th>Purshase Price</th>
                                    <th>Lifespan Years</th>
                                    <th>Bus Consumption</th>
                                    <th>Fuel Consumption</th>

                                    <th>Actions</th>
                                    <th>Seats</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(bus, index) in paginatedBuses"
                                    :key="index"
                                >
                                    <td>{{ bus.number_bus }}</td>
                                    <td>{{ bus.number_passenger }}</td>
                                    <td>{{ bus.Brand }}</td>
                                    <td>{{ bus.purchase_date }}</td>
                                    <td>{{ bus.purchase_price }}</td>
                                    <td>{{ bus.lifespan_years }}</td>
                                    <td>{{ bus.bus_consumption }}</td>
                                    <td>{{ bus.fuel_consumption }}</td>

                                    <td>
                                        <button
                                            class="edit-btn"
                                            @click="openEditModal(bus, index)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                        <button
                                            class="delete-btn"
                                            @click="confirmDeleteBus(bus)"
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="status-btn"
                                            @click="
                                                openSeatsModal(bus.id, index)
                                            "
                                        >
                                            <span class="material-icons"
                                                >visibility</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <button
                                :disabled="currentPage === 1"
                                @click="changePage(currentPage - 1)"
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
                                :disabled="currentPage === totalPages"
                                @click="changePage(currentPage + 1)"
                            >
                                <span class="material-icons">skip_next</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bus Status Modal -->
        <div v-if="showBusStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Bus Status</div>
                <button class="status-btns" @click="fetchBusStatus('pending')">
                    Pending
                </button>
                <button
                    class="status-btns"
                    @click="fetchBusStatus('available')"
                >
                    Available
                </button>
                <button
                    class="status-btns"
                    @click="fetchBusStatus('completed')"
                >
                    Completed
                </button>
                <div class="modal-body">
                    <div v-if="loading1" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!paginatedBusStatusData.length"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Number Bus</th>
                                        <th>Number Passenger</th>
                                        <th>Brand</th>

                                        <th>Purshase Date</th>
                                        <th>Purshase Price</th>
                                        <th>Lifespan Years</th>
                                        <th>Bus Consumption</th>
                                        <th>Fuel Consumption</th>

                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(bus, index) in busStatusData"
                                        :key="index"
                                    >
                                        <td>{{ bus.number_bus }}</td>
                                        <td>{{ bus.number_passenger }}</td>
                                        <td>{{ bus.Brand }}</td>

                                        <td>{{ bus.purchase_date }}</td>
                                        <td>{{ bus.purchase_price }}</td>
                                        <td>{{ bus.lifespan_years }}</td>
                                        <td>{{ bus.bus_consumption }}</td>
                                        <td>{{ bus.fuel_consumption }}</td>
                                        <td>{{ bus.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeBusStatusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Bus Seats Modal -->
        <div v-if="showSeatsModal" class="modal">
            <div class="modal-contentseat">
                <div class="modal-header">
                    Bus Seats (Total: {{ seats.length }})
                </div>
                <div class="modal-body">
                    <div class="seats-container">
                        <div
                            v-for="(seat, index) in seats"
                            :key="seat.seat_id"
                            :class="[
                                'seat',
                                seat.status === 2 ? 'occupied' : '',
                                'seat' + (index + 1),
                            ]"
                        >
                            <span class="material-icons"
                                >airline_seat_recline_normal</span
                            >
                            {{ seat.seat_number }}
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeSeatsModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Edit Bus Modal -->
        <div v-if="showEditModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Bus</div>
                <div class="modal-body">
                    <div class="form-groupd">
                        <label for="numberBus">Purshase Date</label>
                        <input
                            type="date"
                            id="purshasedate"
                            v-model="editedBus.purshasedate"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberPassenger">Brand</label>
                        <input
                            type="text"
                            id="numberPassenger"
                            v-model="editedBus.brand"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Purshase Price</label>
                        <input
                            type="number"
                            id="purshaseprice"
                            v-model="editedBus.purshaseprice"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Lifespan Years</label>
                        <input
                            type="number"
                            id="lifespanyears"
                            v-model="editedBus.lifespanyears"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Bus Consumption</label>
                        <input
                            type="number"
                            id="busconsumption"
                            v-model="editedBus.busconsumption"
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Fuel Consumption</label>
                        <input
                            type="number"
                            id="fuelconsumption"
                            v-model="editedBus.fuelconsumption"
                        />
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="updateBus" class="update-btn">Save</button>
                    <button @click="closeEditModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showEditModal1" class="modal">
            <div class="modal-content">
                <div class="modal-header">Edit Maintenance</div>
                <div class="modal-body">
                    <div class="form-groupd">
                        <label for="path">Bus</label>
                        <div class="select-container">
                            <select v-model="editedBus1.idBus" id="path">
                                <option
                                    v-for="(pathItem, index) in Bus"
                                    :key="index"
                                    :value="pathItem.id"
                                >
                                    {{ pathItem.number_bus }}
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="form-groupd">
                        <label for="numberBus">Cost</label>
                        <input
                            type="number"
                            id="numberBus"
                            v-model="editedBus1.cost"
                            required
                        />
                    </div>
                    <div class="form-groupd">
                        <label for="numberPassenger">Maintenance Date</label>
                        <input
                            type="date"
                            id="numberPassenger"
                            v-model="editedBus1.maintenancedate"
                            required
                        />
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea
                            id="description"
                            v-model="editedBus1.description"
                            placeholder="Enter your description here"
                            class="description-input"
                        ></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="updateBus1" class="update-btn">Save</button>
                    <button @click="closeEditModal1" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- Confirm Delete Modal -->
        <div v-if="showDeleteConfirmModal" class="modals">
            <div class="modals-content">
                <div class="modals-header">Confirm Delete</div>
                <div class="modals-body">
                    Are you sure about the deletion process?
                </div>
                <div class="modals-footer">
                    <button @click="deleteConfirmedBus" class="updates-btn">
                        Yes
                    </button>
                    <button
                        @click="closeDeleteConfirmModal"
                        class="closes-modal"
                    >
                        No
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showDeleteConfirmModal1" class="modals">
            <div class="modals-content">
                <div class="modals-header">Confirm Delete</div>
                <div class="modals-body">
                    Are you sure about the deletion process?
                </div>
                <div class="modals-footer">
                    <button @click="deleteConfirmedBus1" class="updates-btn">
                        Yes
                    </button>
                    <button
                        @click="closeDeleteConfirmModal1"
                        class="closes-modal"
                    >
                        No
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showDeleteConfirmModal2" class="modals">
            <div class="modals-content">
                <div class="modals-header">Confirm Delete</div>
                <div class="modals-body">
                    Are you sure about the deletion process?
                </div>
                <div class="modals-footer">
                    <button @click="deleteConfirmedBus2" class="updates-btn">
                        Yes
                    </button>
                    <button
                        @click="closeDeleteConfirmModal2"
                        class="closes-modal"
                    >
                        No
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
import { debounce } from "lodash";

export default {
    data() {
        return {
            editedBus1: {
                id: "",
                idBus: "",
                maintenancedate: "",
                description: "",
                cost: "",
            },
            maintenancedate: "",
            description: "",
            cost: "",
            Maintenance: [],
            INC: [],
            BusIDD: "",
            insurancedate: "",
            insurancecost: "",
            brand: "",
            showaddmodell: true,
            showmodell: false,
            showmaintenancemodell: false,
            showinsurancemodell: false,
            fuelconsumption: "",
            busconsumption: "",
            lifespanyears: "",
            purshaseprice: "",
            purshasedate: "",
            loading: true,
            loading1: false,
            loading10: true,
            showForm: true,
            Bus: [],
            busStatusData: [],
            seats: [],
            number_bus: "",
            number_passenger: "",
            showBusStatusModal: false,
            showSeatsModal: false,
            showEditModal: false,
            showEditModal1: false,

            showDeleteConfirmModal: false,
            showDeleteConfirmModal1: false,
            showDeleteConfirmModal2: false,

            busToDelete: null,
            editedBus: {
                brand: "",
                id: "",
                fuelconsumption: "",
                busconsumption: "",
                lifespanyears: "",
                purshaseprice: "",
                purshasedate: "",
            },
            editingIndex: null,
            editingIndex1: null,

            toast: useToast(),
            refreshInterval: null,
            currentPage: 1,
            itemsPerPage: 8,
            currentPageBusStatus: 1,
            searchQueryBusStatus: "",
        };
    },
    mounted() {
        this.AllBus();
        this.ALLINC();
        this.Allmaintenance();
    },
    methods: {
        showaddmodel() {
            this.showaddmodell = true;
            this.showmodell = false;
            this.showinsurancemodell = false;
            this.showmaintenancemodell = false;
        },
        showmodel() {
            this.showaddmodell = false;
            this.showmodell = true;
            this.showinsurancemodell = false;
            this.showmaintenancemodell = false;
        },
        showinsurancemodel() {
            this.showaddmodell = false;
            this.showmodell = false;
            this.showinsurancemodell = true;
            this.showmaintenancemodell = false;
        },
        showmaintenancemodel() {
            this.showaddmodell = false;
            this.showmodell = false;
            this.showinsurancemodell = false;
            this.showmaintenancemodell = true;
        },
        closeBusStatusModal() {
            this.showBusStatusModal = false;
        },
        closeSeatsModal() {
            this.showSeatsModal = false;
            this.stopAutoRefresh();
        },
        closeEditModal() {
            this.showEditModal = false;
        },
        closeEditModal1() {
            this.showEditModal1 = false;
        },
        handleSubmit() {
            console.log(
                "Form Submitted",
                this.number_bus,
                this.number_passenger
            );
        },
        Addmaintenance() {
            const token = window.localStorage.getItem("access_token");

            axios
                .post(
                    "http://127.0.0.1:8000/api/company/maintenance-costs/store",
                    {
                        bus_id: this.BusIDD,
                        cost: this.cost,
                        maintenance_date: this.maintenancedate,
                        description: this.description,
                    },
                    {
                        headers: { Authorization: `Bearer ${token}` },
                    }
                )
                .then((response) => {
                    console.log(response);
                    this.toast.success("Maintenance added successfully!");
                    this.Allmaintenance();
                })
                .catch((error) => {
                    console.log(error);
                    this.toast.error("Error ADD");
                });
        },
        AddInsurance() {
            const token = window.localStorage.getItem("access_token");

            axios
                .post(
                    "http://127.0.0.1:8000/api/company/insurance-costs/store",
                    {
                        bus_id: this.BusIDD,
                        insurance_date: this.insurancedate,
                        insurance_cost: this.insurancecost,
                    },
                    {
                        headers: { Authorization: `Bearer ${token}` },
                    }
                )
                .then((response) => {
                    console.log(response);
                    this.toast.success("Insurance added successfully!");
                    this.ALLINC();
                })
                .catch((error) => {
                    console.log(error);
                    this.toast.error("Error ADD");
                });
        },
        AddBus() {
            const token = window.localStorage.getItem("access_token");

            axios
                .post(
                    "http://127.0.0.1:8000/api/company/store_bus",
                    {
                        Brand: this.brand.toString(),
                        number_bus: this.number_bus.toString(),
                        number_passenger: this.number_passenger.toString(),
                        purchase_date: this.purshasedate,
                        purchase_price: this.purshaseprice.toString(),
                        lifespan_years: this.lifespanyears.toString(),
                        bus_consumption: this.busconsumption.toString(),
                        fuel_consumption: this.fuelconsumption.toString(),
                    },
                    {
                        headers: { Authorization: `Bearer ${token}` },
                    }
                )
                .then((response) => {
                    console.log(response);
                    this.toast.success("Bus added successfully!");
                    this.AllBus();
                })
                .catch((error) => {
                    console.log(error);
                    this.toast.error("Error ADD");
                });
        },
        updateBus() {
            const access_token = window.localStorage.getItem("access_token");
            const busId = this.editedBus.id;

            axios
                .put(
                    `http://127.0.0.1:8000/api/company/update_bus/${busId}`,
                    {
                        purchase_date: this.editedBus.purshasedate,
                        purchase_price: this.editedBus.purshaseprice,
                        lifespan_years: this.editedBus.lifespanyears,
                        bus_consumption: this.editedBus.busconsumption,
                        fuel_consumption: this.editedBus.fuelconsumption,
                        rand: this.editedBus.brand,
                    },
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    this.Bus.splice(this.editingIndex, 1, this.editedBus);
                    this.editingIndex = null;
                    this.editedBus = {
                        id: "",
                        fuelconsumption: "",
                        busconsumption: "",
                        lifespanyears: "",
                        purshaseprice: "",
                        purshasedate: "",
                    };
                    console.log(response);

                    this.toast.success("Bus updated successfully!");
                    this.showEditModal = false;
                })
                .catch((error) => {
                    console.log(this.editedBus);

                    this.toast.error("Error updating bus.");
                    console.error(error);
                });
        },
        updateBus1() {
            const access_token = window.localStorage.getItem("access_token");
            const busId = this.editedBus1.id;

            axios
                .put(
                    `http://127.0.0.1:8000/api/company/maintenance-costs/${busId}`,
                    {
                        bus_id: this.editedBus1.idBus,
                        cost: this.editedBus1.cost,
                        maintenance_date: this.editedBus1.maintenancedate,
                        description: this.editedBus1.description,
                    },
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    this.editingIndex1 = null;
                    (this.editedBus1 = {
                        id: "",
                        idBus: "",
                        maintenancedate: "",
                        description: "",
                        cost: "",
                    }),
                        console.log(response);

                    this.toast.success("Maintenance updated successfully!");
                    this.showEditModal1 = false;
                })
                .catch((error) => {
                    console.log(this.editedBus1);

                    this.toast.error("Error updating Maintenance.");
                    console.error(error);
                });
        },
        AllBus() {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .get("http://127.0.0.1:8000/api/company/all_bus", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.Bus = response.data;
                    store.state.Bus = response.data;
                    this.loading = false;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error Getting Bus");
                    console.error(error);
                });
            this.loading = true;
        },
        ALLINC() {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .get("http://127.0.0.1:8000/api/company/insurance-costs", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.INC = response.data;
                    this.loading10 = false;
                    console.log(response.data);
                })
                .catch((error) => {
                    console.error(error);
                });
            this.loading10 = true;
        },
        Allmaintenance() {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .get("http://127.0.0.1:8000/api/company/maintenance-costs", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.Maintenance = response.data;
                    this.loading10 = false;
                    console.log(response.data);
                })
                .catch((error) => {
                    console.error(error);
                });
            this.loading10 = true;
        },
        fetchBusStatus(status) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .get(
                    `http://127.0.0.1:8000/api/company/get_bus_status?status=${status}`,
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    this.busStatusData = response.data;
                    this.loading1 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching bus status");
                    console.error(error);
                });
            this.loading1 = true;
        },
        openEditModal(bus, index) {
            this.editedBus = { ...bus };
            this.editingIndex = index;
            this.showEditModal = true;
        },
        openEditModal1(bus, index) {
            this.editedBus1 = { ...bus };
            this.editingIndex1 = index;
            this.showEditModal1 = true;
        },
        confirmDeleteBus(bus) {
            console.log("Bus selected for deletion:", bus);
            this.busToDelete = bus;
            this.showDeleteConfirmModal = true;
        },
        confirmDeleteBus1(bus) {
            console.log("insurance selected for deletion:", bus);
            this.busToDelete = bus;
            this.showDeleteConfirmModal1 = true;
        },

        confirmDeleteBus2(bus) {
            console.log("insurance selected for deletion:", bus);
            this.busToDelete = bus;
            this.showDeleteConfirmModal2 = true;
        },
        deleteConfirmedBus() {
            if (this.busToDelete && this.busToDelete.id) {
                console.log("Deleting bus:", this.busToDelete);
                this.DeleteBus(this.busToDelete.id);
            } else {
                console.error("No bus selected for deletion.");
            }
            this.closeDeleteConfirmModal();
        },
        deleteConfirmedBus1() {
            this.DeleteBus1(this.busToDelete.id);

            this.closeDeleteConfirmModal1();
        },
        deleteConfirmedBus2() {
            this.DeleteBus2(this.busToDelete.id);

            this.closeDeleteConfirmModal2();
        },
        DeleteBus(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .delete(`http://127.0.0.1:8000/api/company/delete_bus/${id}`, {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then(() => {
                    this.Bus = this.Bus.filter((busItem) => busItem.id !== id);
                    this.toast.success("Bus deleted successfully");
                    this.AllBus();
                })
                .catch((error) => {
                    console.error("Error during deletion:", error);
                    this.toast.error("Error deleting bus");
                });
        },
        DeleteBus2(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .delete(
                    `http://127.0.0.1:8000/api/company/maintenance-costs/${id}`,
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then(() => {
                    this.toast.success("maintenance deleted successfully");
                    this.Allmaintenance();
                })
                .catch((error) => {
                    console.error("Error during deletion:", error);
                    this.toast.error("Error deleting maintenance");
                });
        },
        DeleteBus1(id) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .delete(
                    `http://127.0.0.1:8000/api/company/insurance-costs/${id}`,
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then(() => {
                    this.toast.success("insurance deleted successfully");
                    this.ALLINC();
                })
                .catch((error) => {
                    console.error("Error during deletion:", error);
                    this.toast.error("Error deleting insurance");
                });
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
            this.busToDelete = null;
        },
        closeDeleteConfirmModal1() {
            this.showDeleteConfirmModal1 = false;
            this.busToDelete = null;
            this.ALLINC;
        },
        closeDeleteConfirmModal2() {
            this.showDeleteConfirmModal2 = false;
            this.busToDelete = null;
            this.Maintenance;
        },
        openSeatsModal(busId, index) {
            console.log(
                `Opening seats modal for busId: ${busId}, index: ${index}`
            );
            this.fetchSeats(busId, index);
            this.startAutoRefresh(busId, index);
        },
        fetchSeats: debounce(function (busId, index) {
            const access_token = window.localStorage.getItem("access_token");

            axios
                .post(
                    `http://127.0.0.1:8000/api/company/all_seat_of_bus/${busId}`,
                    {},
                    {
                        headers: { Authorization: `Bearer ${access_token}` },
                    }
                )
                .then((response) => {
                    console.log("Fetched seats:", response.data);
                    this.Bus[index].seats = response.data;
                    this.seats = response.data;
                    this.showSeatsModal = true;
                })
                .catch((error) => {
                    window.alert("Error fetching bus seats");
                    console.error("Fetch seats error:", error);
                });
        }, 300),
        startAutoRefresh(busId, index) {
            console.log("Starting auto-refresh...");
            this.stopAutoRefresh();

            this.refreshInterval = setInterval(() => {
                console.log("Fetching seats...");
                this.fetchSeats(busId, index);
            }, 10000);
        },
        stopAutoRefresh() {
            console.log("Stopping auto-refresh...");
            if (this.refreshInterval) {
                clearInterval(this.refreshInterval);
                this.refreshInterval = null;
            }
        },
        changePage(page) {
            if (page < 1 || page > this.totalPages) return;
            this.currentPage = page;
        },
        prevPage(modalType) {
            if (modalType === "busStatus") {
                if (this.currentPageBusStatus > 1) {
                    this.currentPageBusStatus--;
                }
            } else if (modalType === "bus") {
                if (this.currentPage > 1) {
                    this.currentPage--;
                }
            }
        },
        nextPage(modalType) {
            if (modalType === "busStatus") {
                if (this.currentPageBusStatus < this.totalPagesBusStatus) {
                    this.currentPageBusStatus++;
                }
            } else if (modalType === "bus") {
                if (this.currentPage < this.totalPages) {
                    this.currentPage++;
                }
            }
        },
    },
    computed: {
        filteredBusStatusData() {
            if (!this.searchQueryBusStatus) {
                return this.busStatusData;
            }
            return this.busStatusData.filter((bus) => {
                const searchQuery = this.searchQueryBusStatus.toLowerCase();
                return bus.number_bus
                    .toString()
                    .toLowerCase()
                    .includes(searchQuery);
            });
        },
        paginatedBusStatusData() {
            const start = (this.currentPageBusStatus - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.filteredBusStatusData.slice(start, end);
        },
        totalPagesBusStatus() {
            return Math.ceil(
                this.filteredBusStatusData.length / this.itemsPerPage
            );
        },
        filteredBuses() {
            return store.state.Bus.filter((bus) => {
                const searchQuery = store.state.searchQuery.toLowerCase();
                return bus.number_bus
                    .toString()
                    .toLowerCase()
                    .includes(searchQuery);
            });
        },
        paginatedBuses() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.filteredBuses.slice(start, end);
        },
        totalPages() {
            return Math.ceil(this.filteredBuses.length / this.itemsPerPage);
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

    box-shadow: 0 2rem 3rem var(--clr-light);
}
.select-container {
    position: relative;
    width: 100%;
}

.select-container select {
    width: 100%;
    padding: 10px;
    border: 1px solid var(--clr-primary);
    border-radius: 5px;
    font-size: 16px;
    color: #007bff;
    background-color: var(--clr-white);
    box-sizing: border-box;
    appearance: none;
    text-align: center;
    cursor: pointer;
    transition: border-color 0.3s ease, background-color 0.3s ease;
}

.select-container select:focus {
    border-color: #007bff;
    outline: none;
}

.select-container select:hover {
    background-color: var(--clr-white);
    border-color: #007bff;
}

.select-container::after {
    content: "▼";
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 16px;
    color: #007bff;
    pointer-events: none;
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

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
}

/* Typography */
body {
    font-family: "Roboto", sans-serif;
    width: 100%;
    height: 100%;
    font-size: 0.88rem;
    background: var(--clr-color-background);
    overflow-y: auto;
}

h1 {
    font-size: 1.2rem;
    color: var(--clr-dark);
    margin-bottom: 5px;
}

h2 {
    font-weight: 500;
    font-size: 1.6rem;
    color: var(--clr-dark);
}

h3 {
    font-weight: 500;
    font-size: 1.4rem;
    color: var(--clr-dark);
}

h4 {
    font-weight: 400;
    font-size: 1.2rem;
    color: var(--clr-dark);
}

p {
    font-weight: 400;
    font-size: 1rem;
    color: var(--clr-dark-variant);
}

small {
    font-weight: 400;
    font-size: 0.8rem;
    color: var(--clr-dark-variant);
}

/* Table styling */
.recent_orders {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    overflow-x: auto;
}
table th td {
    vertical-align: middle;
    text-align: center;
    padding: 10px;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: var(--border-radius-2);
    padding: var(--card-padding);
    text-align: center;
    box-shadow: 0 1rem 1.5rem var(--clr-light);
    color: var(--clr-dark);
    font-size: 0.85rem;
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
input::placeholder,
textarea::placeholder {
    font-family: "Poppins", sans-serif;
    font-size: 1rem;
    color: var(--clr-info-dark);
    opacity: 1;
}

/* Input and Textarea styles to ensure consistency */
input,
textarea {
    font-family: "Poppins", sans-serif;
    font-size: 1rem;
}
textarea {
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    transition: border-color 0.3s;
    width: 100%;
    font-size: 1rem;
}

input:focus,
select:focus,
textarea:focus {
    border-color: var(--clr-primary);
}

.pagination span {
    margin: 0 10px;
    font-size: 0.7rem;
    color: var(--clr-dark);
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
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    font-size: 1.2rem;
    color: var(--clr-dark-variant);
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background-color: var(--clr-color-background);
}

.recent_orders table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
    color: var(--clr-dark);
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
    transition: background-color 0.3s ease;
    text-align: center;
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}

table tbody tr:last-child td {
    border: none;
}

/* Select styling */
select {
    padding: 8px;
    border: 1px solid var(--clr-primary);
    border-radius: 4px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: var(--clr-primary-variant);
    box-shadow: 0 0 5px var(--clr-primary-variant);
}

/* Button styling */
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
.delete-btn {
    color: #f44336;
    background-color: var(--clr-white);
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}

.delete-btn:hover {
    color: #fff;
    background-color: #f44336;
}

.status-btn {
    border-radius: 9px;
    background-color: var(--clr-primary);
    transition: background-color 0.3s ease, transform 0.2s;
    color: var(--clr-white);
    width: 30px;
}

.status-btn:hover {
    background-color: var(--clr-primary-variant);
}
.status-btns {
    border-radius: 9px;
    background-color: var(--clr-primary);
    transition: background-color 0.3s ease, transform 0.2s;
    color: var(--clr-white);
    margin: 10px;
    padding: 10px;
}

.status-btns:hover {
    background-color: var(--clr-primary-variant);
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
    width: 100%;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 15px;
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
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
}

input:focus {
    border-color: var(--clr-primary-variant);
}

.submit-btnnd {
    display: flex;
    justify-content: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: var(--clr-primary);
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

.close-modal {
    padding: 10px 20px;
    background-color: var(--clr-danger);
    color: #fff;
    border: none;
    border-radius: var(--border-radius-2);
    cursor: pointer;
    transition: background-color 0.3s;
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

.modals {
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

.modals-content {
    background: var(--clr-white);
    color: var(--clr-dark);
    padding: 15px;
    border-radius: 10px;
    max-width: 400px;
    width: 50%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    text-align: center;
}

.modals-header {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 15px;
}

.modals-body {
    margin-bottom: 20px;
}

.modals-footer {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.updates-btn,
.closes-modal {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.updates-btn {
    background-color: #4caf50;
    color: #fff;
}

.updates-btn:hover {
    background-color: #3c8f3c;
}

.closes-modal {
    background-color: #f44336;
    color: #fff;
}

.closes-modal:hover {
    background-color: #c9302c;
}

/* Seats styling */
.seats-container {
    display: grid;
    grid-template-columns: 1fr 1fr 50px 1fr 1fr;
    gap: 10px;
    justify-content: center;
    width: 250px;
    height: 300px;
    overflow-y: scroll;
    overflow-x: hidden;
    scrollbar-width: none;
}

.modal-contentseat {
    background: var(--clr-white);
    padding: 20px;
    border-radius: 10px;
    max-width: 350px;
    width: 80%;
    box-shadow: 0 2rem 3rem var(--clr-light);
}

.seat {
    width: 30px;
    height: 30px;
    color: var(--clr-primary);
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 5px;
    font-size: 0.8rem;
    transition: transform 0.2s, box-shadow 0.2s;
}

.seat:nth-child(4n + 1) {
    grid-column: 1;
}

.seat:nth-child(4n + 2) {
    grid-column: 2;
}

.seat:nth-child(4n + 3) {
    grid-column: 4;
}

.seat:nth-child(4n + 4) {
    grid-column: 5;
}

.seat:hover {
    transform: scale(1.1);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.seat.occupied {
    background-color: var(--clr-danger);
    color: var(--clr-white);
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
</style>
