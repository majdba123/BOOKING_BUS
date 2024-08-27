<template>
    <div class="containerd">
        <div class="content">
            <div class="recent_orders">
                <h1>Inquiries</h1>
                <div class="navd">
                    <button @click="fetchData('pending')" class="nav-btnd">
                        Pending
                    </button>
                    <button @click="fetchData('completed')" class="nav-btnd">
                        Completed
                    </button>
                </div>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Email</th>
                                <th>Question</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in items" :key="index">
                                <td>{{ item.user_name }}</td>
                                <td>{{ item.email_user }}</td>
                                <td>{{ item.question }}</td>

                                <td>{{ item.status }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div v-if="showItemModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">Inquiry Details</div>
                <div class="modal-body">
                    <p>
                        <strong>User Name:</strong> {{ selectedItem.user_id }}
                    </p>
                    <p><strong>Email:</strong> {{ selectedItem.email }}</p>
                    <p>
                        <strong>Question:</strong> {{ selectedItem.question }}
                    </p>
                    <p><strong>Status:</strong> {{ selectedItem.status }}</p>
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
    name: "inquires_componet",
    data() {
        return {
            items: [],
            showItemModal: false,
            selectedItem: {},
        };
    },
    methods: {
        fetchData(status = null) {
            const toast = useToast();
            const access_token = window.localStorage.getItem("access_token");

            let url = "http://127.0.0.1:8000/api/admin/all_inquires";
            if (status) {
                url = `http://127.0.0.1:8000/api/admin/all_inquires_admin_by_stauts?status=${status}`;
            }

            axios({
                method: "get",
                url: url,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    console.log(response.data);
                    this.items = response.data;
                    toast.success("Data fetched successfully");
                })
                .catch((error) => {
                    toast.error("Error fetching data");
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
    width: 90%;
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
    border-radius: 1rem;
    padding: 1rem;
    text-align: center;
    box-shadow: 0 1rem 1.5rem rgba(132, 139, 200, 0.18);
    color: #363949;
    max-width: none;
    font-size: 0.85rem;
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
    border-radius: 10px;
    max-width: 500px;
    width: 80%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.modal-header {
    font-size: 1.2rem;
    font-weight: bold;
}

.modal-body img {
    margin-top: 10px;
    max-width: 100%;
    border-radius: 10px;
}

.modal-footer {
    display: flex;
    justify-content: center;
}

.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin: 10px;
    transition: all 0.1s ease;
}

.close-modal:hover {
    background-color: #c9302c;
}
</style>
