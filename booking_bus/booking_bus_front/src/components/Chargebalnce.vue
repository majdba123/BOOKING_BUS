<template>
    <div class="containerd">
        <div class="content">
            <div class="recent_orders">
                <h1>Charge Balance Padding</h1>
                <div class="table-container">
                    <div v-if="loading" class="spinner-container">
                        <div class="spinner"></div>
                    </div>
                    <div v-else>
                        <div v-if="!items.length > 0" class="no-data-message">
                            No Data Available
                        </div>
                        <div v-else>
                            <table>
                                <thead>
                                    <tr>
                                        <th>User ID</th>
                                        <th>Image</th>
                                        <th>Point</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr
                                        v-for="(item, index) in items"
                                        :key="index"
                                    >
                                        <td>{{ item.user_id }}</td>
                                        <td>
                                            <img
                                                :src="item.image"
                                                alt="Image"
                                                class="item-image"
                                            />
                                        </td>
                                        <td>{{ item.point }}</td>
                                        <td>{{ item.status }}</td>
                                        <td>
                                            <button
                                                class="nav-btnd accept-btn"
                                                @click="
                                                    acceptOrder(item.user_id)
                                                "
                                            >
                                                Accept
                                            </button>
                                            <button
                                                class="nav-btnd cancel-btn"
                                                @click="
                                                    cancelOrder(item.user_id)
                                                "
                                            >
                                                Cancel
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="showItemModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Item Details</div>
                <div class="modal-body">
                    <p><strong>User ID:</strong> {{ selectedItem.user_id }}</p>
                    <p><strong>Point:</strong> {{ selectedItem.point }}</p>
                    <p><strong>Status:</strong> {{ selectedItem.status }}</p>
                    <img
                        :src="selectedItem.image"
                        alt="Image"
                        class="item-image"
                    />
                </div>
                <div class="modal-footer">
                    <button @click="closeItemModal" class="close-modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
    name: "ChargeBalanceComponent",
    data() {
        return {
            loading: true,

            items: [],
            showItemModal: false,
            selectedItem: {},
        };
    },
    methods: {
        fetchData() {
            const toast = useToast();
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/charge_balance_padding",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.items = response.data;
                    toast.success("Data fetched successfully");
                    this.loading = false;
                })
                .catch((error) => {
                    toast.error("Error fetching data");
                    console.error(error);
                });
            this.loading = true;
        },
        acceptOrder(userId) {
            const toast = useToast();
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/accepted_order_balance/${userId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    toast.success("Order accepted successfully");
                    this.fetchData();
                })
                .catch((error) => {
                    toast.error("Error accepting order");
                    console.error(error);
                });
        },
        cancelOrder(userId) {
            const toast = useToast();
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/cancelled_order_balance/${userId}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then(() => {
                    toast.success("Order cancelled successfully");
                    this.fetchData();
                })
                .catch((error) => {
                    toast.error("Error cancelling order");
                    console.error(error);
                });
        },
        viewItem(item) {
            this.selectedItem = item;
            this.showItemModal = true;
        },
        closeItemModal() {
            this.showItemModal = false;
            this.selectedItem = {};
        },
    },
    mounted() {
        this.fetchData();
    },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap");

.containerd {
    padding: 20px;
    background: #f6f6f9;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
}

.header {
    width: 100%;
}

.content {
    width: 100%;
    max-width: 1200px;
    margin-top: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: #fff;
    border-radius: 10px;
    width: 100%;
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

.accept-btn {
    background: #28a745;
}

.cancel-btn {
    background: #dc3545;
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
.spinner {
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-left-color: #007bff;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}
.nav-btnd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s ease;
}
.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* تجعل الـ spinner يأخذ كامل الشاشة */
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
    background-color: #f6f6f9;
}
.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.recent_orders table {
    background-color: #fff;
    width: 100%;
    border-radius: 10px;
    padding: 1rem;
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    font-size: 0.85rem;
    border-collapse: collapse;
}
.recent_orders tbody tr:hover {
    background-color: #f1f1f1;
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
.recent_orders thead {
    background-color: var(--clr-primary);
    color: #fff;
}

.recent_orders th,
.recent_orders td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid #fff;
    color: #677483;
    transition: background-color 0.3s ease;
}

table tbody tr:hover {
    background-color: #f1f1f1;
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid #363949;
    color: #677483;
}

table tbody tr:last-child td {
    border: none;
}

.item-image {
    width: 50px;
    height: 50px;
    object-fit: cover;
    border-radius: 5px;
}
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
    background: #fff;
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
.modal-body,
.modal-footer {
    margin-bottom: 15px;
}

.modal-header {
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

.modal-body div th {
    background-color: var(--clr-primary);
    color: #fff;
}

.modal-body div td {
    border-bottom: 1px solid #ddd;
}

.profile-image {
    max-width: 100px;
    border-radius: 50%;
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

.close-modal:hover {
    background-color: #c9302c;
}

/* Responsive Design */
@media (max-width: 768px) {
    .modal-content {
        width: 95%;
        height: auto;
    }

    .modal-body {
        flex-direction: column;
    }

    .profile-image {
        max-width: 80px;
    }
}
</style>
