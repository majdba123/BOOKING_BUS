<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnddd" @click="showForm = true">
                Add Company
            </button>
            <button class="nav-btnddd" @click="showForm = false">
                Show All Company
            </button>
        </header>
        <div v-if="showForm" class="form-containerd">
            <form @submit.prevent="handleSubmit" class="form-content">
                <div class="form-groupd">
                    <label for="CompanyName">Company Name</label>
                    <input
                        type="text"
                        id="CompanyName"
                        v-model="name"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="CompanyEmail">Email</label>
                    <input
                        type="email"
                        id="CompanyEmail"
                        v-model="email"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="CompanyPassword">Password</label>
                    <input
                        type="password"
                        id="CompanyPassword"
                        v-model="password"
                        required
                    />
                </div>
                <div class="submit-btnnd">
                    <button
                        type="submit"
                        @click="CreateCompany"
                        class="submit-btnd"
                    >
                        Submit
                    </button>
                </div>
            </form>
        </div>

        <div v-else class="recent_orders">
            <h1>All Company</h1>
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!filteredCompany.length > 0"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name Company</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Driver</th>
                                    <th>Bus</th>
                                    <th>Trip</th>
                                    <th>Reservation</th>
                                    <th>Information</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(user, index) in filteredCompany"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ user.name_company }}</td>
                                    <td>{{ user.user.email }}</td>
                                    <td v-if="user.user.profile?.phone != null">
                                        {{ user.user.profile?.phone }}
                                    </td>
                                    <td v-else>NULL</td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-primary"
                                            @click="
                                                openDriverStatusModal(user.id)
                                            "
                                        >
                                            Driver
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-success"
                                            @click="openBusModal(user.id)"
                                        >
                                            Bus
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-warning"
                                            @click="
                                                openTripModal(
                                                    user.name_company,
                                                    user.id
                                                )
                                            "
                                        >
                                            Trip
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-info"
                                            @click="
                                                openReservationModal(user.id)
                                            "
                                        >
                                            Reservation
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="nav-btnd btn-primary"
                                            @click="openInfoModal(user.id)"
                                        >
                                            Info
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="button-container">
                <button
                    type="button"
                    @click="
                        current_page == first_page
                            ? (current_page = last_page)
                            : (current_page -= 1);
                        AllCompany();
                    "
                >
                    &#10508;
                </button>
                <button
                    type="button"
                    @click="
                        current_page == last_page
                            ? (current_page = first_page)
                            : (current_page += 1);
                        AllCompany();
                    "
                >
                    &#10511;
                </button>
            </div>
        </div>
        <div v-if="showInfoModal" class="modal">
            <div class="modal-contentr">
                <!-- Close button -->
                <div class="modal-body">
                    <!-- Info content in a structured format -->
                    <table class="x">
                        <tr>
                            <th class="y">Pending Reservations</th>
                            <td class="z">{{ info.pending_reservations }}</td>
                        </tr>
                        <tr>
                            <th class="y">Completed Reservations</th>
                            <td class="z">{{ info.completed_reservations }}</td>
                        </tr>
                        <tr>
                            <th class="y">Out Reservation</th>
                            <td class="z">{{ info.out_reservation }}</td>
                        </tr>
                        <tr>
                            <th class="y">Pending Trip</th>
                            <td class="z">{{ info.pending_trip }}</td>
                        </tr>
                        <tr>
                            <th class="y">Finished Trip</th>
                            <td class="z">{{ info.finished_trip }}</td>
                        </tr>
                        <tr>
                            <th class="y">Finished Going Trip</th>
                            <td class="z">{{ info.finished_going_trip }}</td>
                        </tr>
                        <tr>
                            <th class="y">Pending Bus Trip</th>
                            <td class="z">{{ info.pending_bus_trip }}</td>
                        </tr>
                        <tr>
                            <th class="y">Finished Bus Trip</th>
                            <td class="z">{{ info.finished_bus_trip }}</td>
                        </tr>
                        <tr>
                            <th class="y">Finished Going Bus_trip</th>
                            <td class="z">
                                {{ info.finished_going_bus_trip }}
                            </td>
                        </tr>
                        <tr>
                            <th class="y">Total Profit Pending</th>
                            <td class="z">{{ info.total_profit_pending }}</td>
                        </tr>
                        <tr>
                            <th class="y">Total Profit Completed</th>
                            <td class="z">{{ info.total_profit_completed }}</td>
                        </tr>
                        <tr>
                            <th class="y">Total Profit Out</th>
                            <td class="z">{{ info.total_profit_out }}</td>
                        </tr>
                        <tr>
                            <th class="y">All Drivers</th>
                            <td class="z">{{ info.all_drivers }}</td>
                        </tr>
                        <tr>
                            <th class="y">Pending Drivers</th>
                            <td class="z">{{ info.pending_drivers }}</td>
                        </tr>
                        <tr>
                            <th class="y">Available Drivers</th>
                            <td class="z">{{ info.available_drivers }}</td>
                        </tr>
                        <tr>
                            <th class="y">Completed Driver</th>
                            <td class="z">{{ info.completed_driver }}</td>
                        </tr>
                        <tr>
                            <th class="y">All Buses</th>
                            <td class="z">{{ info.allBuses }}</td>
                        </tr>
                        <tr>
                            <th class="y">Completed Buses</th>
                            <td class="z">{{ info.completed_Buses }}</td>
                        </tr>
                        <tr>
                            <th class="y">Available Buses</th>
                            <td class="z">{{ info.availableBuses }}</td>
                        </tr>
                        <tr>
                            <th class="y">Pending Buses</th>
                            <td class="z">{{ info.pending_Buses }}</td>
                        </tr>
                        <tr>
                            <th class="y">inProgress PrivateTrips</th>
                            <td class="z">
                                {{ info.inProgress_PrivateTrips }}
                            </td>
                        </tr>
                        <tr>
                            <th class="y">Completed PrivateTrips</th>
                            <td class="z">{{ info.completed_PrivateTrips }}</td>
                        </tr>
                        <tr>
                            <th class="y">Canceled PrivateTrips</th>
                            <td class="z">{{ info.canceled_PrivateTrips }}</td>
                        </tr>
                        <tr>
                            <th class="y">
                                Total Price Completed PrivateTrips
                            </th>
                            <td class="z">
                                {{ info.total_price_completed_PrivateTrips }}
                            </td>
                        </tr>
                        <tr>
                            <th class="y">Count Favourite</th>
                            <td class="z">{{ info.count_favourite }}</td>
                        </tr>
                        <!-- Add more fields as needed -->
                    </table>
                </div>
                <button @click="closeInfoModal" class="close-modal">
                    Close
                </button>
            </div>
        </div>
        <div v-if="showDriverStatusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Driver Status</div>
                <div class="modal-body">
                    <button
                        class="status-btn"
                        @click="AllDriver(this.currentCompanyId)"
                    >
                        All
                    </button>
                    <button class="status-btn" @click="fetchDriverS('pending')">
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchDriverS('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchDriverS('Completed')"
                    >
                        Completed
                    </button>
                    <div v-if="loading1" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!driverStatusData.length > 0"
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
                                        ) in driverStatusData"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ driver.user.name }}</td>
                                        <td>{{ driver.user.email }}</td>
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
        <div v-if="showBusModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All Bus</div>
                <div class="modal-body">
                    <div v-if="loading2" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!BusData.length > 0" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Number Bus</th>
                                        <th>Number Passenger</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(Bus, index) in BusData"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Bus.number_bus }}</td>
                                        <td>{{ Bus.number_passenger }}</td>
                                        <td>{{ Bus.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeBusModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showTripModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Trip</div>
                <div class="modal-body">
                    <div v-if="loading3" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!Trips.length > 0" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Price</th>
                                        <th>Profit Trip</th>
                                        <th>Bus</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(Trip, index) in Trips"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Trip.from }}</td>
                                        <td>{{ Trip.to }}</td>
                                        <td>{{ Trip.price }}</td>
                                        <td>
                                            <button
                                                class="nav-btnd"
                                                @click="
                                                    openProfitTripModal(
                                                        Trip.trip_id
                                                    )
                                                "
                                            >
                                                Profit
                                            </button>
                                        </td>

                                        <td>
                                            <button
                                                class="nav-btnd"
                                                @click="
                                                    openBusTripModal(
                                                        Trip.trip_id
                                                    )
                                                "
                                            >
                                                Bus
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeTripModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showReservationModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Reservation</div>
                <div class="modal-body">
                    <button
                        class="status-btn"
                        @click="fetchReversationS('padding')"
                    >
                        Pending
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchReversationS('available')"
                    >
                        Available
                    </button>
                    <button
                        class="status-btn"
                        @click="fetchReversationS('Completed')"
                    >
                        Completed
                    </button>
                    <div v-if="loading4" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!ReversationStatusData.length > 0"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Price</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>User Name</th>
                                        <th>Break</th>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Seats</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(
                                            Trip, index
                                        ) in ReversationStatusData"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Trip.price }}</td>
                                        <td>{{ Trip.type }}</td>
                                        <td>{{ Trip.status }}</td>
                                        <td>{{ Trip.user_name }}</td>
                                        <td>{{ Trip.break }}</td>
                                        <td>{{ Trip.from }}</td>
                                        <td>{{ Trip.to }}</td>

                                        <td>
                                            <button
                                                class="nav-btnd"
                                                @click="
                                                    openReservationSeatModal(
                                                        Trip.id
                                                    )
                                                "
                                            >
                                                Seats
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeReservationModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showBusTripModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All BusTrip</div>
                <div class="modal-body">
                    <div v-if="loading5" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!BusTrip.length > 0" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Bus ID</th>
                                        <th>Data Start</th>
                                        <th>Data End</th>
                                        <th>Type</th>
                                        <th>From Time Going</th>
                                        <th>From Time Return</th>
                                        <th>To Time Going</th>
                                        <th>To Time Return</th>
                                        <th>Event</th>
                                        <th>Seats</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(Bus, index) in BusTrip"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Bus.date_start }}</td>
                                        <td>{{ Bus.date_end }}</td>
                                        <td>{{ Bus.type }}</td>
                                        <td>{{ Bus.from_time_going }}</td>
                                        <td>{{ Bus.from_time_return }}</td>
                                        <td>{{ Bus.to_time_going }}</td>
                                        <td>{{ Bus.to_time_return }}</td>
                                        <td>{{ Bus.event }}</td>

                                        <td>
                                            <button
                                                class="nav-btnd"
                                                @click="openSeatsModal(Bus.id)"
                                            >
                                                Seats
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeBusTripModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showProfitTripModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Profit Trip</div>
                <div class="modal-body">
                    <div v-if="loading5" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Total Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>{{ this.profittrip }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closeProfitTripModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showReservationSeatModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All Seats</div>
                <div class="modal-body">
                    <div v-if="loading6" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div
                            v-if="!ReservationSeat.length > 0"
                            class="no-data-message"
                        >
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(Bus, index) in ReservationSeat"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Bus.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button
                        @click="closeReservationSeatModal"
                        class="close-modal"
                    >
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showPivotModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All Pivot</div>
                <div class="modal-body">
                    <div v-if="loading7" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!Pivot.length > 0" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Break Id</th>
                                        <th>Government</th>
                                        <th>Name Break</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(Bus, index) in Pivot"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Bus.government }}</td>
                                        <td>{{ Bus.name_break }}</td>
                                        <td>{{ Bus.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button @click="closePivotModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
        <div v-if="showSeatsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">All Seats</div>
                <div class="modal-body">
                    <div v-if="loading8" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!Seats.length > 0" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Seat ID</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(Bus, index) in Seats"
                                        :key="index"
                                    >
                                        <td>{{ index }}</td>
                                        <td>{{ Bus.status }}</td>
                                    </tr>
                                </tbody>
                            </table>
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
    </div>
</template>

<script>
import axios from "axios";
import store from "@/store";
import { useToast } from "vue-toastification";

export default {
    name: "AddCompany",
    data() {
        return {
            user_id: "",
            profittrip: "",
            current_page: 1,
            last_page: null,
            first_page: null,
            loading: true,
            loading4: true,
            loading5: true,
            loading6: true,
            loading7: true,
            loading8: true,
            loading1: false,
            loading2: true,
            loading3: true,
            currentCompanyId: null,
            idd: "",
            showForm: true,
            Driver: [],
            Company: [],
            Bus: [],
            ReversationStatusData: [],
            driverStatusData: [],
            ReservationSeat: [],
            BusData: [],
            Seats: [],
            Reservation: [],
            Pivot: [],
            BusTrip: [],
            info: [],
            Trips: [],
            driverWithBusData: [],
            name: "",
            email: "",
            password: "",
            showInfoModal: false,

            showDriverStatusModal: false,
            showTripModal: false,
            showReservationModal: false,

            showBusModal: false,
            showBusTripModal: false,
            showProfitTripModal: false,

            showReservationSeatModal: false,

            showPivotModal: false,
            showSeatsModal: false,

            showDriverWithBusModal: false,
            toast: useToast(),
            isDarkMode: false, // إدارة حالة الوضع الداكن
        };
    },
    mounted() {
        this.AllCompany();
        this.isDarkMode = localStorage.getItem("theme") === "dark";
        if (this.isDarkMode) {
            document.body.classList.add("dark-theme-variables");
        }
    },

    methods: {
        openDriverStatusModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.showDriverStatusModal = true;
        },
        openInfoModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.showInfoModal = true;
            this.fetchInfo(this.currentCompanyId);
        },

        openBusModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.fetchBus(this.currentCompanyId);

            this.showBusModal = true;
        },

        openBusTripModal(trip_id) {
            // Set the current company ID
            this.showBusTripModal = true;
            this.idd = trip_id;
            this.fetchBusTrip(trip_id, this.currentCompanyId);
        },
        openProfitTripModal(trip_id) {
            // Set the current company ID
            this.showProfitTripModal = true;
            this.idd = trip_id;
            this.fetctProfitTrip(trip_id, this.currentCompanyId);
        },
        openReservationSeatModal(trip_id) {
            this.fetchReservationSeat(trip_id, this.currentCompanyId);

            // Set the current company ID
            this.idd = trip_id;
            this.showReservationSeatModal = true;
        },

        openSeatsModal(index) {
            // Set the current company ID
            this.showSeatsModal = true;
            this.fetchPivot(index, this.idd, this.currentCompanyId);
        },
        openTripModal(company_id, user_id) {
            this.user_id = user_id;
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.showTripModal = true;
            this.fetchTrip(this.currentCompanyId);
        },
        openReservationModal(company_id) {
            this.currentCompanyId = company_id;
            // Set the current company ID
            this.showReservationModal = true;
            this.fetchReservation(this.currentCompanyId);
        },

        closeDriverStatusModal() {
            this.showDriverStatusModal = false;
        },
        closeInfoModal() {
            this.showInfoModal = false;
        },
        closeTripModal() {
            this.showTripModal = false;
        },
        closeReservationModal() {
            this.showReservationModal = false;
        },
        closeBusModal() {
            this.showBusModal = false;
        },
        closeBusTripModal() {
            this.showBusTripModal = false;
        },
        closeProfitTripModal() {
            this.showProfitTripModal = false;
        },
        closeReservationSeatModal() {
            this.showReservationSeatModal = false;
        },
        closePivotModal() {
            this.showPivotModal = false;
        },
        closeSeatsModal() {
            this.showSeatsModal = false;
        },

        handleSubmit() {
            console.log("Form Submitted", this.name, this.email, this.password);
        },

        fetchReversationS(x) {
            console.log(this.currentCompanyId);
            console.log(x);
            if (x == undefined) {
                this.fetchReservation(this.currentCompanyId);
            }
            this.fetchReversationStatus(this.currentCompanyId, x);
        },
        fetchDriverS(x) {
            console.log(this.currentCompanyId);
            console.log(x);

            this.fetchDriverStatus(this.currentCompanyId, x);
        },

        CreateCompany() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/register/company",
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
                        this.toast.success(
                            "Company account created successfully!"
                        );
                        this.AllCompany();
                    }
                })
                .catch((error) => {
                    if (
                        error.response.data.error &&
                        error.response.data.error.password
                    ) {
                        const x = error.response.data.error?.password[0];
                        this.toast.error(x);
                    }
                    if (
                        error.response.data.error &&
                        error.response.data.error.email
                    ) {
                        const x = error.response.data.error?.email[0];
                        this.toast.error(x);
                    }
                    if (
                        error.response.data.error &&
                        error.response.data.error.name
                    ) {
                        const x = error.response.data.error?.name[0];
                        this.toast.error(x);
                    }

                    console.log(error.response.data.error);
                });
        },

        AllCompany() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url:
                    "http://127.0.0.1:8000/api/admin/all_company?page=" +
                    this.current_page,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Company = response.data.data;
                    this.first_page = response.data.from;
                    this.last_page = response.data.last_page;
                    store.state.Company = response.data;
                    console.log(store.state.Company);
                    this.loading = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting drivers.");
                    console.error(error);
                });
            this.loading = true;
        },
        fetchPivot(x, id, company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/get_all_BusTripsByTripId/${this.user_id}?trip_id=${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.BusTrip = response.data;
                    for (let index = 0; index < response.data.length; index++) {
                        if (response.data[index].id == x) {
                            this.Seats = response.data[index].seats;
                        }
                    }

                    this.loading7 = false;
                    this.loading8 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading7 = true;
        },
        fetchBusTrip(id, company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/get_all_BusTripsByTripId/${this.user_id}?trip_id=${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.BusTrip = response.data;

                    console.log(response.data);
                    this.loading5 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading5 = true;
        },
        fetctProfitTrip(id, company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/get_profit_trip/${id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.profittrip = response.data.total_price;
                    console.log(response.data);

                    this.loading5 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading5 = true;
        },
        fetchTrip(company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/fillter_all_trip?company_name=${company_name}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Trips = response.data;
                    console.log(this.BusData);
                    this.loading3 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading3 = true;
        },
        fetchReservationSeat(id, company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_reservation_of_company/${company_name}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    // تحقق من وجود response.data[id] ووجود bus_trips
                    this.ReservationSeat = response.data[id - 1].seats;
                    console.log(this.ReservationSeat);
                    this.loading6 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading6 = true;
        },
        fetchReservation(company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_reservation_of_company/${company_name}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Reservation = response.data;
                    this.ReversationStatusData = response.data;
                    console.log(this.Reservation);
                    this.loading4 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading4 = true;
        },
        fetchInfo(company_name) {
            console.log(company_name);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/company_all_info/${company_name}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.info = response.data;
                    console.log(this.info);
                    this.loading4 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading4 = true;
        },
        fetchBus(company_id) {
            console.log(company_id);
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_bus_by_id_company/${company_id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.BusData = response.data;
                    console.log(this.BusData);
                    this.loading2 = false;
                })
                .catch((error) => {
                    this.toast.error("Error getting buses.");
                    console.error(error);
                });
            this.loading2 = true;
        },
        AllDriver(company_id) {
            console.log(company_id);

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_driver_by_company/${company_id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverStatusData = response.data;
                    console.log(response.data);
                    this.loading1 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading1 = true;
        },
        fetchReversationStatus(company_id, status) {
            console.log(company_id);
            console.log(status);

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_reservation_of_company__by_status/${company_id}?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.ReversationStatusData = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
        },
        fetchDriverStatus(company_id, status) {
            console.log(company_id);
            console.log(status);

            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/all_driver_status_by_id_company/${company_id}?status=${status}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.driverStatusData = response.data;
                    console.log(response.data);
                    this.loading1 = false;
                })
                .catch((error) => {
                    window.alert("Error fetching driver status");
                    console.error(error);
                });
            this.loading1 = true;
        },

        toggleTheme() {
            this.isDarkMode = !this.isDarkMode;
            document.body.classList.toggle(
                "dark-theme-variables",
                this.isDarkMode
            );
            localStorage.setItem("theme", this.isDarkMode ? "dark" : "light");
        },
    },

    computed: {
        filteredCompany() {
            const companies = store.state.Company.data || [];

            return companies.filter((driver) => {
                const nameCompany = driver.name_company
                    ? driver.name_company.toLowerCase()
                    : "";
                const email =
                    driver.user && driver.user.email
                        ? driver.user.email.toLowerCase()
                        : "";
                const status = driver.status ? driver.status.toLowerCase() : "";

                return (
                    nameCompany.includes(
                        store.state.searchQuery.toLowerCase()
                    ) ||
                    email.includes(store.state.searchQuery.toLowerCase()) ||
                    status.includes(store.state.searchQuery.toLowerCase())
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

.table-container {
    width: 100%;
    overflow-x: auto;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
    background: var(--clr-color-background);
    color: var(--clr-dark-variant);
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
    transition: background-color 0.3s ease;
}
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: var(--clr-white);
    border-radius: 5px;
    width: 100%;
    max-width: 1100px;
    padding: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    margin-left: 3rem;
}

.nav-btnddd {
    padding: 10px 20px;
    margin: 0 10px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 14px;
    font-weight: bold;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
    flex-grow: 1;
    text-align: center;
}

.nav-btnddd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
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

table tbody tr:hover {
    background-color: var(--clr-light);
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    font-size: 1.2rem;
    color: #677483;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background-color: var(--clr-color-background);
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
    font-size: 0.85rem;
    outline: none;
    transition: border-color 0.3s, box-shadow 0.3s;
}

select:focus {
    border-color: var(--clr-primary);
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
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
.modal-containerr {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.5);
}

.modal-contentr {
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

.close-buttonr {
    position: absolute;
    top: 10px;
    right: 10px;
    background: red;
    color: white;
    border: none;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    cursor: pointer;
}

.x {
    width: 100%;
    border-collapse: collapse;
}

.y,
.z {
    padding: 10px;
    border: 1px solid #ddd;
    text-align: left;
}

.y {
    background-color: #f2f2f2;
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
.cancel-btn {
    color: #4caf50;
    background-color: #f1f1f1;
    border-radius: 9px;
    width: 29px;
    padding: 2px;
    margin: 5px;
}
.cancel-btn:hover {
    color: #fff;
    background-color: #4caf50;
}

.delete-btn {
    color: #f44336;
    background-color: #f1f1f1;
    border-radius: 9px;
    padding: 3px;
}

.delete-btn:hover {
    color: #fff;
    background-color: #f44336;
}
/* Navigation styling */
.button-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 20px 0;
}

button {
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1.2rem;
    transition: background-color 0.3s ease, transform 0.2s ease;
    margin: 0 5px;
}

button:hover {
    background-color: var(--clr-primary-variant);
    transform: scale(1.05);
}

button:active {
    transform: scale(0.95);
}

button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.nav-btnd.btn-primary {
    background: #7380ec;
}

.nav-btnd.btn-success {
    background: #4caf50;
}

.nav-btnd.btn-warning {
    background: #ff9800;
}

.nav-btnd.btn-info {
    background: #17a2b8;
}

.nav-btnd.btn-danger {
    background: #f44336;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
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

/* Form styling */

input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
}

input:focus {
    border-color: #007bff;
}

.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 40px;
    background-size: cover;
    border-radius: 15px;
    width: 100%;
    transition: background-color 0.3s ease;
}
.form-content {
    background-color: rgba(var(--clr-white), 0.9);
    padding: 40px;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.2);
    border-radius: 15px;
    width: 100%;
    max-width: 600px;
    animation: slideIn 0.6s ease-in-out;
}
.form-groupd {
    margin-bottom: 20px;
    width: 100%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: var(--clr-dark);
}
.form-groupd input {
    width: 100%;
    padding: 12px;
    border-radius: 5px;
    border: 1px solid #ccc;
    transition: border-color 0.3s;
}

.form-groupd input:focus {
    border-color: var(--clr-primary);
    outline: none;
}

.submit-btnnd {
    display: flex;
    justify-content: center;
}

.submit-btnnd {
    display: flex;
    justify-content: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-dark);
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s, transform 0.2s;
}

.submit-btnd:hover {
    background-color: var(--clr-primary-variant);
    transform: translateY(-3px);
}

/* Animations */
@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Responsive Design */
@media (max-width: 768px) {
    .form-content {
        padding: 30px;
    }

    .form-groupd input {
        padding: 10px;
    }

    .submit-btnd {
        padding: 10px 20px;
    }
}

@media (max-width: 480px) {
    .navd {
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: var(--clr-white);
        border-radius: 5px;
        width: 90%;
        padding: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-left: 1rem;
    }
    .form-content {
        padding: 20px;
    }

    .submit-btnd {
        padding: 8px 16px;
    }
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
@media (max-width: 768px) {
    .modal-content {
        width: 95%;
        height: auto;
    }

    .modal-body div {
        flex-direction: column;
    }

    .profile-image {
        max-width: 80px;
    }
}
.close-modal:hover {
    background-color: #c9302c;
}

.modal-body div th {
    background-color: var(--clr-primary);
    color: #fff;
}

.modal-body div td {
    border-bottom: 1px solid #ddd;
}

.status-btn {
    padding: 8px 16px;
    margin: 5px;
    margin-bottom: 0.5rem;
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
.recent_orders {
    width: 100%;
    margin-top: 20px;
    margin-left: 1.2rem;
}
.recent_orders thead {
    background-color: var(--clr-primary);
    color: #fff;
}
.recent_orders th,
.recent_orders td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}
@media (max-width: 1200px) {
    .recent_orders table {
        font-size: 0.75rem;
    }
}
@media (max-width: 768px) {
    .recent_orders table,
    .recent_orders thead,
    .recent_orders tbody,
    .recent_orders th,
    .recent_orders td,
    .recent_orders tr {
        display: block;
    }

    .recent_orders thead tr {
        position: absolute;
        top: -9999px;
        left: -9999px;
    }

    .recent_orders tr {
        border: 1px solid #ddd;
        margin-bottom: 10px;
        display: flex;
        flex-direction: column;
    }

    .recent_orders td {
        border: none;
        position: relative;
        padding-left: 50%;
        text-align: left;
    }

    .recent_orders td::before {
        content: attr(data-label);
        position: absolute;
        left: 0;
        width: 45%;
        padding-left: 10px;
        white-space: nowrap;
        font-weight: bold;
        color: var(--clr-primary);
    }
}

.recent_orders td {
    text-align: center;
}
.recent_orders table {
    background: var(--clr-color-background);
    width: 100%;
    border-radius: var(--border-radius-2);
    padding: 1rem;
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    font-size: 0.85rem;
    border-collapse: collapse;
}

/* Responsive Design */
@media screen and (max-width: 768px) {
    .container {
        width: 100%;
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
</style>
