<template>
    <body class="bg-slate-100">
        <main>
            <div class="container">
                <div
                    v-for="Not in Notification"
                    :key="Not.id"
                    class="post-container"
                >
                    <div class="post">
                        <div class="post-header">
                            <div class="user-info">
                                <div class="user-details">
                                    <h4>
                                        <span> User ID: </span>{{ Not.user_id }}
                                    </h4>
                                </div>
                                <div class="report-button">
                                    <span>Create AT: {{ Not.created_at }}</span>
                                </div>
                            </div>
                        </div>
                        <div class="post-content">
                            <p>
                                {{ Not.notification }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</template>

<script>
import axios from "axios";

export default {
    name: "NotificationComponent",
    data() {
        return {
            Notification: [],
        };
    },
    methods: {
        notification() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/my_notification",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Notification = response.data;
                })
                .catch(() => {
                    this.toast.error("Error getting Notification.");
                });
            this.loading = true;
        },
    },
    mounted() {
        this.notification();
    },
};
</script>
<style scoped>
body {
    background-color: #f1f5f9;
    font-family: Arial, sans-serif;
}

.container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
    color: #6b7280;
}

.post-container {
    width: 100%;
    display: flex;
    justify-content: center;
}

.post {
    background-color: #ffffff;
    border-radius: 8px;
    width: 100%;
    max-width: 1200px;
    padding: 20px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
}

.post-header {
    align-items: center;
    padding-bottom: 20px;
    border-bottom: 2px solid #e5e7eb;
}

.user-info {
    justify-content: space-between !important;

    display: flex;
    align-items: center;
    gap: 10px;
}

.user-info img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.user-details h4 {
    font-weight: bold;
    color: #000;
    margin: 0;
}

.user-details span {
    font-size: 0.9rem;
    color: #6b7280;
}

.report-button {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 5px 10px;
    border: 1px solid #d1d5db;
    border-radius: 4px;
    color: #6b7280;
    text-decoration: none;
    font-size: 0.9rem;
}

.report-button img {
    width: 16px;
    height: 16px;
}

.post-content {
    padding: 20px 0;
    color: #000;
}

.post-footer {
    display: flex;
    gap: 10px;
    padding-top: 10px;
    border-top: 1px solid #e5e7eb;
}

.action-button {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 5px 10px;
    border: 1px solid #d1d5db;
    border-radius: 4px;
    color: #6b7280;
    text-decoration: none;
    font-size: 0.9rem;
}

.action-button img {
    width: 16px;
    height: 16px;
}
</style>
