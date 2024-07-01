<template>
    <div class="main-content">
        <NavBar />
        <div class="content">
            <div class="header">
                <button @click="showMenu = !showMenu">
                    <i class="fas fa-user"></i>
                </button>
                <ul class="menuu" v-if="showMenu">
                    <li>Account Settings</li>
                    <li @click="logout">Sign Out</li>
                </ul>
            </div>
            <div class="contentt">
                <div class="total1">
                    <div class="logo">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="50"
                            height="50"
                            fill="currentColor"
                            class="bi bi-universal-access"
                            viewBox="0 0 16 16"
                        >
                            <path
                                d="M9.5 1.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0M6 5.5l-4.535-.442A.531.531 0 0 1 1.531 4H14.47a.531.531 0 0 1 .066 1.058L10 5.5V9l.452 6.42a.535.535 0 0 1-1.053.174L8.243 9.97c-.064-.252-.422-.252-.486 0l-1.156 5.624a.535.535 0 0 1-1.053-.174L6 9z"
                            />
                        </svg>
                    </div>
                    <div class="discription">
                        <div class="Trip">Total Trip</div>
                        <div class="number">5</div>
                    </div>
                </div>
                <div class="total2">
                    <div class="logo">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="50"
                            height="50"
                            fill="currentColor"
                            class="bi bi-ticket-fill"
                            viewBox="0 0 16 16"
                        >
                            <path
                                d="M1.5 3A1.5 1.5 0 0 0 0 4.5V6a.5.5 0 0 0 .5.5 1.5 1.5 0 1 1 0 3 .5.5 0 0 0-.5.5v1.5A1.5 1.5 0 0 0 1.5 13h13a1.5 1.5 0 0 0 1.5-1.5V10a.5.5 0 0 0-.5-.5 1.5 1.5 0 0 1 0-3A.5.5 0 0 0 16 6V4.5A1.5 1.5 0 0 0 14.5 3z"
                            />
                        </svg>
                    </div>
                    <div class="discription">
                        <div class="Trip">Total Ticket Booking</div>
                        <div class="number">5</div>
                    </div>
                </div>
                <div class="total3">
                    <div class="logo">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="50"
                            height="50"
                            fill="currentColor"
                            class="bi bi-cash-stack"
                            viewBox="0 0 16 16"
                        >
                            <path
                                d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4"
                            />
                            <path
                                d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2z"
                            />
                        </svg>
                    </div>
                    <div class="discription">
                        <div class="Trip">Total Booking Amount</div>
                        <div class="number">5</div>
                    </div>
                </div>
                <div class="total4">
                    <div class="logo">
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            width="50"
                            height="50"
                            fill="currentColor"
                            class="bi bi-person-lines-fill"
                            viewBox="0 0 16 16"
                        >
                            <path
                                d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-5 6s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zM11 3.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5m.5 2.5a.5.5 0 0 0 0 1h4a.5.5 0 0 0 0-1zm2 3a.5.5 0 0 0 0 1h2a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h2a.5.5 0 0 0 0-1z"
                            />
                        </svg>
                    </div>
                    <div class="discription">
                        <div class="Trip">Total Passenger</div>
                        <div class="number">5</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBar from "@/components/NavBar.vue";
import router from "@/router";
import axios from "axios";
export default {
    name: "AdminPage",
    components: {
        NavBar,
    },
    data() {
        return { showMenu: false };
    },
    methods: {
        logout() {
            const token = window.localStorage.getItem("access_token");
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/logout",
                headers: { Authorization: `Bearer ${token}` },
            }).then(function (response) {
                if (response.status == 200) {
                    console.log(response);
                    window.alert("Logout succesful");
                    window.localStorage.setItem(
                        "access_token",
                        response.data.access_token
                    );
                    router.push("/");
                }
            });
        },
    },
};
</script>
<style lang="scss">
.main-content {
    display: flex;
    width: 100%;
}
.content {
    flex: 1600%;
}
.header {
    border-radius: 10px;
    height: 70px;
    width: 100%;
    background-color: white;
    display: flex;
    direction: rtl; /* تحديد الاتجاه من اليمين إلى اليسار */
}
.header button {
    background-color: #f4f5f5;
    width: 40px;
    margin: 13px;
    border-radius: 10px;
    border: none;
    border-style: solid;
}
.header button i {
    color: black;
    text-shadow: 2px 2px 2px white;
}
.menuu {
    height: 80px;
    position: absolute;
    width: 13%;
    left: 1250px;
    background-color: #f9f9f9;
    border: 1px solid #ccc;
    border-radius: 15px;
    min-width: 100px;
    margin: 40px;
    padding: 5px;
    top: 20px;
}
.menuu li {
    color: black;
    text-align: center;
    padding: 10px;
    border-bottom: 1px solid rgb(0, 0, 0, 0.1);
}
.menuu li:last-child {
    border-bottom: none;
}
.menuu li:hover {
    background-image: linear-gradient((to right, #007bff, #00bfff, #87ceeb));
    border-radius: 15px;
    cursor: pointer;
}
.contentt {
    display: flex;
    width: 100%;
    justify-content: space-between;
}
.total1 {
    width: 100%;
    text-align: center;
    margin: 15px;
    padding: 30px;
    border-radius: 15px;
    background-image: linear-gradient((to right, #1e90ff, #ff69b4));
    justify-content: space-between;
    display: flex;
}
.total2 {
    width: 100%;

    text-align: center;
    margin: 15px;
    padding: 30px;
    border-radius: 15px;
    background-image: linear-gradient((to right, #800080, #ffd700));
    justify-content: space-between;
    display: flex;
}
.total3 {
    width: 100%;

    text-align: center;
    margin: 15px;
    padding: 30px;
    border-radius: 15px;
    background-image: linear-gradient((to right, #007bff, #00bfff, #87ceeb));
    justify-content: space-between;
    display: flex;
}
.total4 {
    width: 100%;

    text-align: center;
    margin: 15px;
    padding: 30px;
    border-radius: 15px;
    background-image: linear-gradient((to right, #008000, #98fb98));
    justify-content: space-between;
    display: flex;
}
.discription {
    display: block;
    margin: 6px;
    text-align: center;
}
.Trip,
.number {
    font-size: 19px;
    margin-bottom: 5px;
}
</style>
