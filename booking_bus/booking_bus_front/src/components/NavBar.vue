<template>
    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />

    <div class="main-content">
        <div class="menu">
            <ul>
                <li class="profile">
                    <h2>LOGO</h2>
                </li>
                <li class="profile">
                    <div class="img-box">
                        <img src="تنزيل.webp" alt="Profile Image" />
                    </div>
                    <h2>Admin</h2>
                </li>

                <li>
                    <a class="active" href="">
                        <i>
                            <svg
                                xmlns="http://www.w3.org/2000/svg"
                                width="35"
                                height="35"
                                fill="currentColor"
                                class="bi bi-house"
                                viewBox="0 0 16 16"
                            >
                                <path
                                    d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z"
                                />
                            </svg>
                        </i>
                        <p>Dashboard</p>
                    </a>
                </li>
                <li>
                    <router-link to="/CreateCompany" class="nav-link">
                        <i class="fas fa-user-group"></i>
                        <p>Add Company</p>
                    </router-link>
                </li>
                <li
                    class="dropdown"
                    @mouseenter="showDropdown1"
                    @mouseleave="hideDropdown1"
                >
                    <a href="#" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <p>Government</p>
                    </a>
                    <ul v-show="dropdownVisible1" class="dropdown-content">
                        <router-link to="/AddGovernment"
                            >Add Government</router-link
                        >
                        <router-link to="/EditGovernment"
                            >Edit Government</router-link
                        >
                    </ul>
                </li>

                <li>
                    <a href="">
                        <i class="fas fa-chart-pie"></i>
                        <p>Bookings</p>
                    </a>
                </li>

                <li
                    class="dropdown"
                    @mouseenter="showDropdown"
                    @mouseleave="hideDropdown"
                >
                    <a href="#" class="nav-link">
                        <i class="fas fa-table"></i>
                        <p>Breaks</p>
                    </a>
                    <ul v-show="dropdownVisible" class="dropdown-content">
                        <router-link to="/AddBreak">Add Break</router-link>
                        <router-link to="/EditBreak">Edit Break</router-link>
                    </ul>
                </li>

                <li class="log-out">
                    <i class="fas fa-sign-out"></i>
                    <div class="nav-link"></div>
                    <p class="nav-link" @click="logout">Log Out</p>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import router from "@/router";

export default {
    name: "NavBar",
    data() {
        return {
            dropdownVisible: false,
            dropdownVisible1: false,
            dropdownVisible2: false,
        };
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
                    window.alert("Logout successful");
                    window.localStorage.setItem("access_token", "");
                    router.push("/");
                }
            });
        },
        showDropdown() {
            this.dropdownVisible = true;
        },
        hideDropdown() {
            this.dropdownVisible = false;
        },
        showDropdown2() {
            this.dropdownVisible2 = true;
        },
        hideDropdown2() {
            this.dropdownVisible2 = false;
        },
        showDropdown1() {
            this.dropdownVisible1 = true;
        },
        hideDropdown1() {
            this.dropdownVisible1 = false;
        },
    },
};
</script>

<style lang="scss">
* {
    padding: 0;
    margin: 0;
    color: white;
    font-family: sans-serif;
}
body {
    background-color: #f4f5f5;
}

.main-content {
    display: flex;
    width: 100%;
}
.img-box {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    overflow: hidden;
    border: 3px solid white;
    flex-shrink: 0;
}
.img-box img {
    width: 100%;
}

.profile {
    display: flex;
    align-items: center;
    gap: 30px;
}
.profile h2 {
    font-size: 20px;
    text-transform: capitalize;
}

.menu {
    background-color: #2f3234;
    width: 45px;
    height: 100%;
    padding: 20px;
    overflow: hidden;
    transition: 0.6s;
    border-radius: 6px;
    position: fixed; /* اجعل القائمة ثابتة */
    top: 0; /* اجعل القائمة في أعلى الشاشة */
    left: 0; /* اجعل القائمة في الجانب الأيسر من الشاشة */
}
.menu:hover {
    width: 260px;
}

ul {
    list-style: none;
    position: relative;
    height: 95%;
}
ul li a {
    display: block;
    text-decoration: none;
    padding: 10px;
    margin: 10px 0;
    border-radius: 8px;
    display: flex;
    align-items: center;
    gap: 40px;
    transition: 0.5s;
}
ul li a:hover {
    background-color: #176b87;
}

.log-out {
    position: absolute;
    bottom: 0;
    width: 100%;
}
.log-out a {
    transition: 0.5s;
}

.log-out a:hover {
    background-color: #176b87;
}

ul li a i {
    font-size: 25px;
}
.content {
    width: 100%;
    margin: 10px;
}

.menu li a {
    position: relative; /* تحديد العنصر كمرجع للموقع النسبي */
}

.menu li a::after {
    content: " >";
    position: absolute; /* تحديد موقع العلامة بشكل مطلق داخل العنصر الأصل */
    left: 90%; /* وضع العلامة في أقصى اليمين */
    margin-left: 10px; /* يمكنك تعديل المسافة حسب الحاجة */
    visibility: hidden; /* إخفاء العلامة بشكل افتراضي */
}

.menu li a:hover::after {
    visibility: visible; /* إظهار العلامة عند التمرير فوق العنصر */
}
</style>
