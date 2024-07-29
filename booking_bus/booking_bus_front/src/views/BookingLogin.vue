<template>
    <body>
        <div class="container">
            <!-- Aside section start -->
            <aside ref="sideMenu">
                <!-- Start top -->
                <div class="top">
                    <div class="logo">
                        <h2>T<span class="danger">RAVEL</span></h2>
                    </div>
                    <div class="close" @click="closeMenu">
                        <span class="material-icons" aria-label="Close"
                            >close</span
                        >
                    </div>
                </div>
                <!-- End top -->

                <!-- Start sidebar -->
                <div class="sidebar">
                    <a href="#">
                        <span class="material-icons" aria-label="Dashboard"
                            >grid_view</span
                        >
                        <h3>Dashboard</h3>
                    </a>
                    <a href="#" class="active">
                        <span class="material-icons" aria-label="Customers"
                            >person_outline</span
                        >
                        <h3>Customers</h3>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Analytics"
                            >insights</span
                        >
                        <h3>Analytics</h3>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Messages"
                            >mail_outline</span
                        >
                        <h3>Messages</h3>
                        <span class="msg_count">14</span>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Products"
                            >receipt_long</span
                        >
                        <h3>Products</h3>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Reports"
                            >report_gmailerrorred</span
                        >
                        <h3>Reports</h3>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Settings"
                            >settings</span
                        >
                        <h3>Settings</h3>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Add Product"
                            >add</span
                        >
                        <h3>Add Product</h3>
                    </a>
                    <a href="#">
                        <span class="material-icons" aria-label="Logout"
                            >logout</span
                        >
                        <h3>Logout</h3>
                    </a>
                </div>
                <!-- End sidebar -->
            </aside>
            <!-- Aside section end -->

            <!-- Main section start -->
            <main>
                <h1>Dashboard</h1>
                <div class="top-bar">
                    <div class="date">
                        <input
                            type="text"
                            placeholder="Search In..."
                            aria-label="Search"
                        />
                        <button>Search</button>
                    </div>
                </div>
                <div class="insights">
                    <!-- Start selling -->
                    <div class="sales">
                        <span class="material-icons" aria-label="Sales"
                            >trending_up</span
                        >
                        <div class="middle">
                            <div class="left">
                                <h3>Total Sales</h3>
                                <h1>$25,024</h1>
                            </div>
                            <div class="progress">
                                <svg>
                                    <circle
                                        class="background-circle"
                                        r="30"
                                        cy="40"
                                        cx="40"
                                    ></circle>
                                    <circle
                                        class="sales-circle"
                                        r="30"
                                        cy="40"
                                        cx="40"
                                    ></circle>
                                </svg>
                                <div class="number">80%</div>
                            </div>
                        </div>
                        <small>Last 24 Hours</small>
                    </div>
                    <!-- End selling -->

                    <!-- Start expenses -->
                    <div class="expenses">
                        <span class="material-icons" aria-label="Expenses"
                            >local_mall</span
                        >
                        <div class="middle">
                            <div class="left">
                                <h3>Expenses</h3>
                                <h1>$25,024</h1>
                            </div>
                            <div class="progress">
                                <svg>
                                    <circle
                                        class="background-circle"
                                        r="30"
                                        cy="40"
                                        cx="40"
                                    ></circle>
                                    <circle
                                        class="expenses-circle"
                                        r="30"
                                        cy="40"
                                        cx="40"
                                    ></circle>
                                </svg>
                                <div class="number">80%</div>
                            </div>
                        </div>
                        <small>Last 24 Hours</small>
                    </div>
                    <!-- End expenses -->

                    <!-- Start income -->
                    <div class="income">
                        <span class="material-icons" aria-label="Income"
                            >stacked_line_chart</span
                        >
                        <div class="middle">
                            <div class="left">
                                <h3>Income</h3>
                                <h1>$25,024</h1>
                            </div>
                            <div class="progress">
                                <svg>
                                    <circle
                                        class="background-circle"
                                        r="30"
                                        cy="40"
                                        cx="40"
                                    ></circle>
                                    <circle
                                        class="income-circle"
                                        r="30"
                                        cy="40"
                                        cx="40"
                                    ></circle>
                                </svg>
                                <div class="number">80%</div>
                            </div>
                        </div>
                        <small>Last 24 Hours</small>
                    </div>
                    <!-- End income -->
                </div>
                <!-- End insights -->

                <!-- Start recent orders -->
                <div class="recent_orders">
                    <h1>Name Companys</h1>
                    <table>
                        <thead>
                            <tr>
                                <th>Company Name</th>
                                <th>Count User</th>
                                <th>Location</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>A Shahen</td>
                                <td>200</td>
                                <td>Aleppo</td>
                                <td class="warning">Pending</td>
                                <td class="primary">Details</td>
                            </tr>
                            <!-- Repeat similar rows for demonstration -->
                            <tr>
                                <td>A Shahen</td>
                                <td>200</td>
                                <td>Aleppo</td>
                                <td class="warning">Pending</td>
                                <td class="primary">Details</td>
                            </tr>
                            <tr>
                                <td>A Shahen</td>
                                <td>200</td>
                                <td>Aleppo</td>
                                <td class="warning">Pending</td>
                                <td class="primary">Details</td>
                            </tr>
                            <tr>
                                <td>A Shahen</td>
                                <td>200</td>
                                <td>Aleppo</td>
                                <td class="warning">Pending</td>
                                <td class="primary">Details</td>
                            </tr>
                            <tr>
                                <td>A Shahen</td>
                                <td>200</td>
                                <td>Aleppo</td>
                                <td class="warning">Pending</td>
                                <td class="primary">Details</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- End recent orders -->
            </main>
            <!-- Main section end -->

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

                <!--start recent_updates-->

                <div class="recent_updates">
                    <h2>Name Companys</h2>
                    <div class="updates">
                        <div class="update">
                            <div class="profile-photo">
                                <img src="@/assets/busss.png" alt="Profile" />
                            </div>
                            <div class="message">
                                <p><b>Babar</b> Received his order</p>
                            </div>
                        </div>
                        <div class="update">
                            <div class="profile-photo">
                                <img src="@/assets/busss.png" alt="Profile" />
                            </div>
                            <div class="message">
                                <p><b>Babar</b> Received his order</p>
                            </div>
                        </div>
                        <div class="update">
                            <div class="profile-photo">
                                <img src="@/assets/busss.png" alt="Profile" />
                            </div>
                            <div class="message">
                                <p><b>Babar</b> Received his order</p>
                            </div>
                        </div>
                    </div>
                </div>
                <!--end recent_updates-->
            </div>
            <!-- Right section end -->
        </div>
    </body>
</template>

<script>
export default {
    methods: {
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
            const themeToggler = this.$refs.themeToggler;
            if (themeToggler) {
                themeToggler
                    .querySelector("span:nth-child(1)")
                    .classList.toggle("active");
                themeToggler
                    .querySelector("span:nth-child(2)")
                    .classList.toggle("active");
            }
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
    overflow: hidden;
    font-size: 0.88rem;
    user-select: none;
    overflow-x: hidden;
    background: #f6f6f9;
}

.container {
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
}

a {
    color: #363949;
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
}

h2 {
    font-size: 1.4rem;
}

h3 {
    font-size: 0.87rem;
}

h4 {
    font-size: 0.8rem;
}

h5 {
    font-size: 0.77rem;
}

small {
    font-size: 0.75rem;
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
    color: #7380ec;
}

.success {
    color: var(--clr-success);
}

.danger {
    color: #ff7782;
}

.warning {
    color: #ffbb55;
}

/* aside */
aside {
    height: 100vh;
    background-color: #fff;
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

/* .sidebar */
aside .sidebar {
    background-color: #fff;
    display: flex;
    flex-direction: column;
    height: calc(100vh - 5rem);
    position: relative;
}

aside h3 {
    font-weight: 400;
}

aside .sidebar a {
    display: flex;
    align-items: center;
    margin-left: 2rem;
    color: #7d8da1;
    height: 3.2rem;
    text-decoration: none;
    gap: 1rem;
    transition: all 0.1s ease-in;
}

aside .sidebar a span {
    font-size: 1.6rem;
    transition: all 0.1s ease-in;
}

aside .sidebar a:last-child {
    position: absolute;
    bottom: 1rem;
    width: 100%;
}

aside .sidebar a.active {
    background: rgba(132, 139, 200, 0.18);
    color: #7380ec;
    margin-left: 0;
}

aside .sidebar a.active::before {
    content: "";
    width: 6px;
    height: 100%;
    background-color: #7380ec;
}

aside .sidebar a:hover {
    color: #7380ec;
}
aside .top .close span {
    display: none;
}
aside .sidebar a:hover span {
    margin-left: 1rem;
    transition: 0.4s ease;
}

aside .sidebar a span.msg_count {
    background: #ff7782;
    color: #fff;
    padding: 2px 5px;
    font-size: 11px;
    border-radius: 0.4rem;
}

/* Main section styles */
main {
    margin-top: 1.4rem;
    width: 100%;
}

main input {
    background-color: transparent;
    border: 0;
    outline: 0;
    color: #363949;
}

main .top-bar {
    display: flex;
    gap: 1rem;
    align-items: center;
}

main .date {
    display: inline-block;
    background-color: #fff;
    border-radius: 0.9rem;
    padding: 9px;
    margin-top: 9px;
}

main .date button {
    padding: 0.5rem 1rem;
    border: none;
    background-color: #007bff;
    color: #fff;
    border-radius: 1rem;
    cursor: pointer;
    margin-left: 5px;
}

main .date button:hover {
    background-color: #0056b3;
    transition: 0.4s ease-in;
}

main .insights {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.6rem;
}

main .insights > div {
    background-color: #fff;
    padding: 1.8rem;
    border-radius: 2rem;
    margin-top: 1rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
}

main .insights > div:hover {
    box-shadow: none;
}

main .insights > div span {
    background: coral;
    padding: 0.5rem;
    border-radius: 50%;
    color: #fff;
    font-size: 2rem;
}

main .insights > div.expenses span {
    background: #ff7782;
}

main .insights > div.income span {
    background: #41f1b6;
}

main .insights > div .middle {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

main .insights > div .middle h1 {
    font-size: 1.6rem;
}

main h1 {
    color: #363949;
}

main .insights h1 {
    color: #363949;
}

main .insights h3 {
    color: #363949;
}

main .insights p {
    color: #363949;
}

main .insights .progress {
    position: relative;
    height: 68px;
    width: 68px;
    border-radius: 50px;
}

main .insights svg {
    height: 100%;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
}

main .insights svg circle.background-circle {
    fill: none;
    stroke: #e4e9f7;
    stroke-width: 6;
}

main .insights svg circle.sales-circle {
    fill: none;
    stroke: #7380ec;
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

main .insights svg circle.expenses-circle {
    fill: none;
    stroke: #ff7782;
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

main .insights svg circle.income-circle {
    fill: none;
    stroke: #41f1b6;
    stroke-width: 5;
    stroke-dasharray: 188.4;
    stroke-dashoffset: 37.68;
    transform: rotate(-90deg);
    transform-origin: 34.5px 40px;
}

main .insights .progress .number {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 1.2rem;
    color: #363949;
}

main .recent_orders h1 {
    margin: 18px;
    color: #363949;
}

main .recent_orders table {
    background-color: #fff;
    width: 100%;
    border-radius: 2rem;
    padding: 1.8rem;
    text-align: center;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
    color: #363949;
}

main .recent_orders table:hover {
    box-shadow: none;
}

main table thead tr th {
    padding: 15px;
}

main table tbody tr {
    height: 3.8rem;
    border-bottom: 1px solid #fff;
    color: #677483;
}

main table tbody td {
    height: 3.8rem;
    border-bottom: 1px solid #363949;
    color: #677483;
}

main table tbody tr:last-child td {
    border: none;
}

main .recent_orders a {
    text-align: center;
    display: block;
    margin: 1rem;
}

/************
        start right side
***************************** */
.right {
    margin-top: 1.4rem;
    padding: 1rem;
    background-color: #f6f6f9;
}

.right .top {
    display: flex;
    justify-content: space-between;
    gap: 2rem;
}

.right .top button {
    display: none;
}

.right .theme-toggler {
    background-color: #fff;
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
    background-color: #7380ec;
    color: #fff;
    border-radius: 10px;
}

.right .profile {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.right .profile .info p {
    margin: 0;
}

.right .profile .profile-photo img {
    width: 2.8rem;
    height: 2.8rem;
    border-radius: 50%;
    overflow: hidden;
}

/***recent update */
.right .recent_updates {
    margin-top: 1rem;
    margin-left: -20px;
}
.right .recent_updates h2 {
    color: #363949;
    margin-bottom: 14px;
}

.right .recent_updates .updates {
    background-color: #fff;
    padding: 1.8rem;
    border-radius: 2rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    transition: all 0.3s ease;
}

.right .recent_updates .updates:hover {
    box-shadow: none;
}

.right .recent_updates .update {
    display: grid;
    grid-template-columns: 2.6rem auto;
    gap: 1rem;
    margin-bottom: 1rem;
}

/**********
media query
********** */
@media screen and (max-width: 1200px) {
    .container {
        width: 94%;
        grid-template-columns: 7rem auto 14rem;
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

    aside {
        position: fixed;
        width: 18rem;
        z-index: 3;
        background-color: #fff;
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
        background-color: #fff;
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
        background-color: #7380ec;
        color: #fff;
        border-radius: 10px;
    }
}
</style>
