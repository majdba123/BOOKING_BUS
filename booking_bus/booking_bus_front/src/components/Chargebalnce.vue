<template>
    <div class="containerd">
        <div class="content">
            <div class="recent_orders">
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
                                        <td>{{ index }}</td>
                                        <td>
                                            <img
                                                :src="item.image"
                                                alt="Image"
                                                class="item-image"
                                                @click="viewImage(item.image)"
                                            />
                                        </td>
                                        <td>{{ item.point }}</td>
                                        <td>{{ item.status }}</td>
                                        <td>
                                            <button
                                                class="nav-btnd accept-btn"
                                                @click="acceptOrder(item.id)"
                                            >
                                                Accept
                                            </button>
                                            <button
                                                class="nav-btnd cancel-btn"
                                                @click="cancelOrder(item.id)"
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

        <div v-if="showImageModal" class="image-modal" @click="closeImageModal">
            <div class="image-modal-content">
                <img :src="selectedImage" alt="Large Image" />
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
            showImageModal: false,
            selectedImage: "",
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
                    console.log(response.data);
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
        viewImage(image) {
            this.selectedImage = image;
            this.showImageModal = true;
        },
        closeImageModal() {
            this.showImageModal = false;
            this.selectedImage = "";
        },
    },
    mounted() {
        this.fetchData();
    },
};
</script>

<style scoped>
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

.dark-theme-variables {
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --box-shadow: 0 2rem 3rem var(--clr-light);
}

.containerd {
    padding: 20px;
    background: var(--clr-color-background);
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
    display: flex;
    flex-direction: column;
    align-items: center;
}
.image-modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.8);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.image-modal-content img {
    max-width: 80%;
    max-height: 80%;
    border-radius: 10px;
    box-shadow: 0 0 15px rgba(255, 255, 255, 0.2);
}

.image-modal-content {
    position: relative;
    text-align: center;
}

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
    border-radius: 25px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
}

.accept-btn {
    background: var(--clr-success);
}

.cancel-btn {
    background: var(--clr-danger);
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

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}

.nav-btnd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s ease;
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

.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders {
    width: 100%;
    margin-top: 20px;
    margin-left: 1.2rem;
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

.recent_orders tbody tr:hover {
    background-color: var(--clr-light);
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
    color: var(--clr-white);
}

.recent_orders th,
.recent_orders td {
    padding: 10px;
    border-bottom: 1px solid #ddd;
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
    background: var(--clr-white);
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
    color: var(--clr-white);
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
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-2);
    cursor: pointer;
    transition: background-color 0.3s;
}

.close-modal:hover {
    background-color: #c9302c;
}

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
