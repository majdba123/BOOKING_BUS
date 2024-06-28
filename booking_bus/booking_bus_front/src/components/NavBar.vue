<template>
    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />

    <div class="main-content">
        <div class="menu">
            <ul>
                <li class="profile">
                    <div class="img-box">
                        <img src="تنزيل.webp" alt="" />
                    </div>
                    <h2>Name Company</h2>
                </li>

                <li>
                    <a class="active" href="">
                        <i class="fas fa-home"></i>
                        <p>dashboard</p>
                    </a>
                </li>

                <li>
                    <a href="">
                        <i class="fas fa-user-group"></i>
                        <p>clients</p>
                    </a>
                </li>
                <li>
                    <router-link to="/PathTrip" class="nav-link">
                        <i class="fas fa-table"></i>
                        <p>Trips</p>
                    </router-link>
                </li>

                <li>
                    <a href="">
                        <i class="fas fa-chart-pie"></i>
                        <p>bookings</p>
                    </a>
                </li>

                <li>
                    <a href="">
                        <i class="fas fa-pen"></i>
                        <p>Private Trips</p>
                    </a>
                </li>

                <li class="log-out">
                    <a href="">
                        <i class="fas fa-sign-out"></i>
                        <p>Log Out</p>
                    </a>
                </li>
            </ul>
        </div>

        <div class="content">
            <div class="title-info">
                <p>dashboard</p>
                <i class="fas fa-chart-bar"></i>
            </div>

            <div class="data-info">
                <div class="box">
                    <i class="fas fa-user"></i>
                    <div class="data">
                        <p>user</p>
                        <span>100</span>
                    </div>
                </div>
                <div class="box">
                    <i class="fas fa-pen"></i>
                    <div class="data">
                        <p>Private Trips</p>
                        <span>100</span>
                    </div>
                </div>
                <div class="box">
                    <i class="fas fa-table"></i>
                    <div class="data">
                        <p>Bookings</p>
                        <span>100</span>
                    </div>
                </div>
                <div class="box">
                    <i class="fas fa-dollar"></i>
                    <div class="data">
                        <p>revenue</p>
                        <span>100</span>
                    </div>
                </div>
            </div>

            <div class="title-info">
                <p>Bookings</p>
                <i class="fas fa-table"></i>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>price</th>
                        <th>count</th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td>Damascus</td>
                        <td><span class="price">200$</span></td>
                        <td><span class="count">20</span></td>
                        <td>
                            <span class="price"
                                ><i class="fa fa-trash"></i
                            ></span>
                        </td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<style lang="scss">
* {
    padding: 0;
    margin: 0;
    color: white;
    font-family: sans-serif;
}
body {
    background-color: #f4fbff;
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
    background-color: #1b262c;
    width: 45px;
    height: 100vh;
    padding: 20px;
    overflow: hidden;
    transition: 0.6s;
    border-radius: 6px;
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
.title-info {
    background-color: #1b262c;
    padding: 10px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-radius: 8px;
    margin: 10px 0;
}

.data-info {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 10px;
}

.data-info .box {
    background-color: #1b262c;
    height: 150px;
    flex-basis: 150px;
    flex-grow: 1;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: space-around;
}
.data-info .box:hover,
td:hover {
    background-color: #176b87;
    transition: 0.5s ease;
}
.data-info .box i {
    font-size: 40px;
}
.data-info .box .data {
    text-align: center;
}
.data-info .box .data p {
    margin-bottom: 10px;
    font-size: 15px;
}
.data-info .box .data span {
    font-size: 30px;
}

table {
    width: 100%;
    text-align: center;
    border-spacing: 8px;
}
td,
th {
    background-color: #1b262c;
    height: 40px;
    border-radius: 8px;
}
th {
    background-color: #1b262c;
}
.price,
.count,
.delete {
    padding: 6px;
    border-radius: 6px;
}
</style>
