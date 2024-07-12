<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="continer">
                <div class="title">
                    <p>Bus List</p>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Number Bus</th>
                            <th>Number Passenger</th>

                            <th>Seat</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(bus, index) in Bus" :key="index">
                            <td>
                                {{ bus.number_bus }}
                            </td>
                            <td>
                                {{ bus.number_passenger }}
                            </td>
                            <td>
                                <button @click="editPath(bus.id)">View</button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div v-if="editingIndex !== null" class="modal">
                    <div class="seat-booking-container">
                        <h1>All Seat</h1>
                        <div class="seat-grid">
                            <div
                                v-for="(seat, index) in seats"
                                :key="index"
                                :class="{ seat: true, reserved: seat.reserved }"
                                @click="toggleReservation(index)"
                            >
                                {{ seat.id }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";
import axios from "axios";

export default {
    name: "AllBus",
    components: { NavBarCompany },
    data() {
        return {
            editingIndex: null,
            Bus: "",
            id: "",
            seats: [],
        };
    },
    mounted() {
        this.fetchBus();
    },
    methods: {
        editPath(busId) {
            this.editingIndex = busId;
            this.fetchSeats(busId);
        },
        toggleReservation(seatIndex) {
            const seat = this.seats[seatIndex];
            seat.reserved = !seat.reserved;
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
                .catch((error) => {
                    window.alert("Error get paths");
                    console.error(error);
                });
        },
        fetchSeats(busId) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/company/all_seat_of_bus/${busId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.seats = response.data;
                })
                .catch((error) => {
                    console.log(busId);
                    window.alert("Error fetching seats");
                    console.error(error);
                });
        },
        DeleteBus(x) {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "delete",
                url: `http://127.0.0.1:8000/api/company/delete_bus/${x}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    window.alert("Deleted Complete");
                    window.location.reload();
                })
                .catch((error) => {
                    window.alert("Error deleting bus");
                    console.error(x);
                    console.error(error);
                });
        },
    },
};
</script>

<style scoped>
/* Modal styles */
.modal {
    display: flex;
    align-items: center;
    justify-content: center;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
    max-width: 500px;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
.seat-booking-container {
    max-width: 500px;
    margin: auto;
    width: 80%;
    border-radius: 10px;
    text-align: center;

    text-align: center;
    background-color: #176b87;
    padding: 20px;
    border: 1px solid #888;
}
.seat-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
}
.seat {
    padding: 10px;
    background-color: #204e5e;
    border: 1px solid #ddd;
    cursor: pointer;
    transition: transform 0.2s;
}
.seat:hover {
    transform: scale(1.1);
}
.reserved {
    background-color: #204e5e;
}
.main-content {
    display: flex;
    width: 100%;
}
.content {
    flex: 1600%;
}
* {
    margin: 0;
    padding: 0;
    outline: none;
    border: none;
    text-decoration: none;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
}
.continer {
    width: 90%;
    margin: 20px auto;
    text-align: center;
}
.title p {
    padding: 15px;
    background-color: #176b87;
    border-radius: 15px;
    text-align: center;
    font-size: 26px;
}

.table {
    border-collapse: collapse;
    table-layout: fixed;
    width: 100%;
    font-size: 13px;
    min-width: 100%;
    overflow: hidden;
    border-radius: 4px;
    margin: 11px auto;
}

.table thead tr {
    background: #176b87;
    text-align: left;
    font-weight: bold;
    color: white;
}

.table th,
.table td {
    padding: 12px 15px;
    text-align: center;
    word-break: break-all;
}

.table th {
    color: white;
}

.table td {
    color: #000000;
    background: #e9e9e9;
}

.table button {
    padding: 6px 20px;
    border-radius: 10px;
    cursor: pointer;
    color: #fff;
    background-color: #176b87;
    border: 1px solid #ffffff;
}

.table button a {
    color: #fff;
}

.table button:hover {
    background: #204e5e;
    color: #fff;
    transition: 0.5s;
}

tr td a {
    color: #000000;
}

tr td a:hover,
.dd:hover {
    color: #ffffff;
}
</style>
