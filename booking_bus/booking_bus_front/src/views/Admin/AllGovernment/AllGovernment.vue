<template>
    <div class="container">
        <!-- Aside section start -->
        <aside ref="sideMenu">
            <!-- Start top -->
            <div class="top">
                <div class="logo">
                    <h2>T<span class="danger">RAVEL</span></h2>
                </div>
                <div class="close" @click="closeMenu">
                    <span class="material-icons" aria-label="Close">close</span>
                </div>
            </div>
            <!-- End top -->

            <!-- Start sidebar -->
            <SidebarAdmin />
            <!-- End sidebar -->
        </aside>
        <div class="main-content">
            <main>
                <h1>Government</h1>
                <div class="top-bar">
                    <div class="date">
                        <input
                            type="text"
                            placeholder="Search By Name..."
                            aria-label="Search"
                            v-model="searchQuery"
                        />
                        <button @click="search">Search</button>
                    </div>
                    <GoogleMap class="map-container" />
                </div>
                <AddGovernment ref="addGovernment" />
            </main>
        </div>
        <!-- Right section start -->
        <div class="right">
            <!--start top-->
            <div class="top">
                <button id="menu_bar" @click="openMenu">
                    <span class="material-icons">menu</span>
                </button>
                <div
                    class="theme-toggler"
                    ref="themeToggler"
                    @click="toggleTheme"
                >
                    <span class="material-icons active">light_mode</span>
                    <span class="material-icons">dark_mode</span>
                </div>
                <div class="profile">
                    <div class="info">
                        <p><b>Babar</b></p>
                        <p>Admin</p>
                    </div>
                    <div class="profile-photo">
                        <img src="@/assets/busss.png" alt="Profile" />
                    </div>
                </div>
            </div>
            <!--end top-->

            <!--start driver_chart-->
            <div class="driver_chart">
                <h2>Government Workload Status</h2>
                <DriverChart :chartData="chartData" />
            </div>

            <!--start driver_status-->
            <div class="driver_status">
                <h2>Government Status</h2>
                <div class="statuses">
                    <div class="status">
                        <div class="info">
                            <p><b>Name:</b></p>
                            <p class="p">ali mohamad</p>
                        </div>
                        <div class="info">
                            <p><b>Status:</b></p>
                            <p class="p">موجود</p>
                        </div>
                    </div>
                </div>
            </div>
            <!--end driver_status-->
        </div>
        <!-- Right section end -->
    </div>
</template>

<script>
import SidebarAdmin from "@/components/SidebarAdmin.vue";
import AddGovernment from "@/components/AddGovernment.vue";
import DriverChart from "@/components/DriverChart.vue";
import store from "@/store";
import router from "@/router";

export default {
    name: "AllDriver",
    components: { SidebarAdmin, AddGovernment, DriverChart },
    data() {
        return {
            x: store.state.x,
            searchQuery: "",
            Driver: [],
            Bus: [],
            chartData: {
                labels: ["Under Pressure", "Not Working"],
                datasets: [
                    {
                        label: "Driver Workload Status",
                        data: [60, 40],
                        backgroundColor: [
                            "rgba(255, 99, 132, 0.2)",
                            "rgba(75, 192, 192, 0.2)",
                        ],
                        borderColor: [
                            "rgba(255, 99, 132, 1)",
                            "rgba(75, 192, 192, 1)",
                        ],
                        borderWidth: 1,
                    },
                ],
            },
            isDarkMode: false, // لإدارة حالة الوضع الداكن
        };
    },
    watch: {
        searchQuery(newQuery) {
            store.commit("updateSearchQuery", newQuery);
            // console.log(store.state.searchQuery);
        },
    },
    methods: {
        checkToken() {
            // الحصول على التوكن من localStorage
            const token = window.localStorage.getItem("access_token");
            const userType = window.localStorage.getItem("type_user");

            if (token && userType) {
                // توجيه المستخدم بناءً على نوع الصفحة التي يجب أن يتوجه إليها
                if (userType === "company") {
                    router.push("/HomeView");
                } else if (userType === "user") {
                    router.push("/HomeView");
                }
            }
        },
        openMenu() {
            const sideMenu = this.$refs.sideMenu;
            if (sideMenu) {
                sideMenu.style.display = "block";
            }
        },
        closeMenu() {
            const sideMenu = this.$refs.sideMenu;
            if (sideMenu) {
                sideMenu.style.display = "none";
            }
        },
        toggleTheme() {
            this.isDarkMode = !this.isDarkMode; // تغيير حالة الوضع الداكن
            document.body.classList.toggle(
                "dark-theme-variables",
                this.isDarkMode
            );
            localStorage.setItem(
                "darkMode",
                this.isDarkMode ? "enabled" : "disabled"
            ); // حفظ الحالة في localStorage

            const themeToggler = this.$refs.themeToggler;
            themeToggler
                .querySelector("span:nth-child(1)")
                .classList.toggle("active", !this.isDarkMode);
            themeToggler
                .querySelector("span:nth-child(2)")
                .classList.toggle("active", this.isDarkMode);
        },
        search() {
            // هنا يمكنك تنفيذ وظيفة البحث
        },
    },
    mounted() {
        this.checkToken();
        // التحقق من تفضيلات المستخدم المحفوظة في localStorage
        const savedTheme = localStorage.getItem("darkMode");
        if (savedTheme === "enabled") {
            this.isDarkMode = true;
            document.body.classList.add("dark-theme-variables");
        } else {
            this.isDarkMode = false;
            document.body.classList.remove("dark-theme-variables");
        }

        const themeToggler = this.$refs.themeToggler;
        themeToggler
            .querySelector("span:nth-child(1)")
            .classList.toggle("active", !this.isDarkMode);
        themeToggler
            .querySelector("span:nth-child(2)")
            .classList.toggle("active", this.isDarkMode);
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
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --box-shadow: 0 2rem 3rem var(--clr-light);
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
    background: var(--clr-color-background); /* هنا يتم ضبط الخلفية */
    overflow-y: auto;
}

.container {
    background: var(--clr-color-background); /* تأكد من ضبط الخلفية هنا أيضًا */
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 19rem;
    margin-left: 0;
    height: 100vh;
    overflow-y: auto;
}

a {
    color: var(--clr-dark);
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
    margin-top: 20px;
    color: var(--clr-dark);
}

h2 {
    font-size: 1.4rem;
    color: var(--clr-dark);
}

h3 {
    font-size: 0.87rem;
    color: var(--clr-dark);
}

h4 {
    font-size: 0.8rem;
    color: var(--clr-dark);
}

h5 {
    font-size: 0.77rem;
    color: var(--clr-dark);
}

small {
    font-size: 0.75rem;
    color: var(--clr-dark);
}

.profile-photo img {
    width: 2.8rem;
    height: 2.8rem;
    border-radius: 50%;
    overflow: hidden;
}

.text-muted {
    color: #7d8da1;
}

.primary {
    color: var(--clr-primary);
}

.success {
    color: var(--clr-success);
}

.danger {
    color: var(--clr-danger);
}

.warning {
    color: var(--clr-warning);
}

/* aside */
aside {
    height: 100vh;
    background-color: var(--clr-white);
    display: flex;
    flex-direction: column;
    padding: 1rem;
}

aside .top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

aside .logo {
    display: flex;
    gap: 1rem;
}

.top-bar {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.map-container {
    margin: 10px;
    flex: 1;
}

.date {
    display: flex;
    align-items: center;
    gap: 1rem;
    background-color: var(--clr-white);
    border-radius: 0.9rem;
    padding: 9px;
    margin-top: 15px;
    margin-left: 10px;
}

.date input {
    flex: 1;
}

.date button {
    padding: 0.5rem 1rem;
    border: none;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border-radius: 1rem;
    cursor: pointer;
}

.date button:hover {
    background-color: var(--clr-primary-variant);
    transition: 0.4s ease-in;
}

/* Main section styles */
/*
          start right side
  ***************************** */
.right {
    margin-top: 1.4rem;
    padding: 1rem;
    background-color: var(--clr-color-background);
    grid-column: span 1;
}

.right .top {
    display: flex;
    justify-content: space-between;
    gap: 2rem;
    margin-left: 15px;
}

.right .top button {
    display: none;
}

.right .theme-toggler {
    background-color: var(--clr-white);
    display: flex;
    justify-content: space-between;
    height: 1.6rem;
    width: 4.2rem;
    cursor: pointer;
    border-radius: 10px;
}

.right .theme-toggler span {
    font-size: 1.2rem;
    width: 50%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.right .theme-toggler span.active {
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border-radius: 10px;
}

.right .profile {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.right .profile .info p {
    margin: 0;
    color: var(--clr-dark);
}

.right .profile .profile-photo img {
    width: 2.8rem;
    height: 2.8rem;
    border-radius: 50%;
    overflow: hidden;
}

.right .driver_status {
    margin-top: 4rem;
    background: var(--clr-white);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.right .driver_status h2 {
    color: var(--clr-dark);
    margin-bottom: 14px;
    margin-left: 42px;
}

.right .driver_status .statuses {
    padding: 1rem;
}

.right .driver_status .status {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 10px;
}

.right .driver_status .status .info {
    margin-left: 10px;
    align-items: center;
}

.right .driver_status .status .info p {
    margin: 10px;
}

.p {
    display: flex;
    justify-content: center;
    align-items: center;
}

.driver_chart {
    margin-top: 3rem;
    background: var(--clr-white);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.driver_chart h2 {
    color: var(--clr-dark);
    margin-bottom: 14px;
    margin-left: 42px;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: 2rem;
    padding: 1.8rem;
    text-align: center;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
    color: var(--clr-dark);
    max-width: 100px;
}

.recent_orders table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: 15px;
}

table tbody tr {
    height: 3.8rem;
    border-bottom: 1px solid var(--clr-white);
    color: #677483;
}

table tbody td {
    height: 3.8rem;
    border-bottom: 1px solid var(--clr-dark);
    color: #677483;
}

table tbody tr:last-child td {
    border: none;
}

.recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
}

/* Select styling */
select {
    padding: 10px;
    border: 1px solid var(--clr-primary);
    border-radius: 5px;
    background-color: var(--clr-white);
    color: var(--clr-dark);
    font-size: 0.88rem;
    outline: none;
    transition: border-color 0.3s;
}

select:focus {
    border-color: var(--clr-primary-variant);
}

/* Delete button styling */
.delete-btn {
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    border: 1px solid var(--clr-danger);
    background-color: var(--clr-white);
    color: var(--clr-danger);
}

.delete-btn:hover {
    background-color: var(--clr-danger);
    color: var(--clr-white);
}

/**********
  media query
  ********** */
@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 18rem;
    }
    aside .sidebar h3 {
        display: none;
    }
    aside .sidebar a span.msg_count {
        padding: 1px 4px;
        font-size: 10px;
        border-radius: 0.2rem;
    }
    aside .sidebar a:hover span {
        margin: 0;
    }
    aside .top .close span {
        display: none;
    }
    aside .sidebar a:last-child {
        position: relative;
        margin-top: 1.8rem;
    }

    main .insights {
        display: grid;
        grid-template-columns: repeat(1, 1fr);
        gap: 1.6rem;
        padding: 40px;
    }
}

/* Mobile Responsive */
@media screen and (max-width: 768px) {
    .container {
        width: 100%;
        grid-template-columns: repeat(1, 1fr);
    }
    .map-container {
        margin: 30px;
    }

    aside {
        position: fixed;
        width: 18rem;
        z-index: 3;
        background-color: var(--clr-white);
        display: none;
        left: -100px;
        animation: menuAni 1s forwards;
    }
    @keyframes menuAni {
        to {
            left: 0;
        }
    }

    aside .logo {
        display: inline;
    }

    aside .sidebar h3 {
        display: inline;
    }

    aside .sidebar a {
        width: 100%;
        height: 3.4rem;
    }

    aside .top .close span {
        display: inline;
        position: absolute;
        right: 0;
        font-size: 35px;
        margin-right: 30px;
    }

    .right .top {
        position: fixed;
        top: 0;
        left: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 0.8rem;
        background-color: var(--clr-white);
        width: 100%;
        height: 4.6rem;
        z-index: 2;
        box-shadow: 0 1rem 1rem 0 2rem 3rem rgba(132, 139, 200, 0.18);
        margin: 0;
    }

    main .insights {
        display: grid;
        grid-template-columns: repeat(1, 1fr);
        gap: 1.6rem;
        padding: 40px;
    }

    main .recent_orders {
        padding: 30px;
        margin: 0 auto;
    }
    main .date {
        margin-top: 40px;
        margin-left: 44px;
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
        color: var(--clr-dark);
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
