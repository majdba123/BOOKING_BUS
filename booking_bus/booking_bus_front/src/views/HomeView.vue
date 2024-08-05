<template>
    <div class="login-container">
        <div class="login-box" ref="loginBox">
            <img src="@/assets/logoo.png" alt="Logo" class="logo" />
            <h1 v-if="isLogin">Login to Book Your Bus</h1>
            <h1 v-else>Register to Book Your Bus</h1>
            <form @submit.prevent="isLogin ? login() : register()">
                <input
                    type="text"
                    v-model="username"
                    placeholder="Username"
                    v-if="!isLogin"
                    required
                />
                <input
                    type="text"
                    v-model="email"
                    placeholder="Email"
                    required
                />
                <input
                    type="password"
                    v-model="password"
                    placeholder="Password"
                    required
                />
                <button type="submit">
                    {{ isLogin ? "Login" : "Register" }}
                </button>
                <button type="button" @click="toggleForm" class="toggle-btn">
                    {{ isLogin ? "Register" : "Login" }}
                </button>
            </form>
            <a href="#" class="forgot-password" v-if="isLogin"
                >Forgot Password?</a
            >
        </div>
    </div>
</template>

<script>
import axios from "axios";
import router from "@/router";
import anime from "animejs";

export default {
    name: "HomeView",
    data() {
        return {
            email: "",
            password: "",
            username: "",
            isLogin: true,
        };
    },
    mounted() {
        anime({
            targets: this.$refs.loginBox,
            translateY: [-50, 0],
            opacity: [0, 1],
            duration: 1000,
            easing: "easeOutExpo",
        });
    },
    methods: {
        toggleForm() {
            this.isLogin = !this.isLogin;
            this.email = "";
            this.password = "";
            this.username = "";
            anime({
                targets: this.$refs.loginBox,
                translateY: [-50, 0],
                opacity: [0, 1],
                duration: 1000,
                easing: "easeOutExpo",
            });
        },
        register() {
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/register",
                data: {
                    name: this.username,
                    email: this.email,
                    password: this.password,
                },
            })
                .then((response) => {
                    if (response.status === 200) {
                        console.log(response);
                        window.alert("Registration successful");
                        window.localStorage.setItem(
                            "access_token",
                            response.data.access_token
                        );
                        this.login();
                    }
                })
                .catch((error) => {
                    alert("Error during registration");
                    console.log(error);
                });
        },
        login() {
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/login",
                data: {
                    email: this.email,
                    password: this.password,
                },
            })
                .then((response) => {
                    if (response.status === 200) {
                        console.log(response);
                        window.alert("Login successful");
                        window.localStorage.setItem(
                            "access_token",
                            response.data.access_token
                        );

                        const userType = response.data.type_user;
                        if (userType === "admin") {
                            router.push("/AdminPage");
                        } else if (userType === "company") {
                            router.push("/CompanyPage");
                        } else if (userType === "user") {
                            router.push("/UserPage");
                        } else {
                            router.push("/");
                        }
                    }
                })
                .catch((error) => {
                    window.alert("Invalid email or password");
                    console.log(error);
                });
        },
    },
};
</script>

<style scoped>
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: url("@/assets/busss.png") no-repeat center center;
    background-size: cover;
}
.login-box {
    background: rgba(255, 255, 255, 0.9);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: center;
    width: 100%;
    max-width: 400px;
    opacity: 0;
}

.login-box .logo {
    max-width: 150px;
    margin-bottom: 20px;
}

.login-box h1 {
    font-size: 28px;
    margin-bottom: 20px;
    color: #333;
}

.login-box input {
    width: 95%;
    padding: 10px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 16px;
}

.login-box button {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border: none;
    border-radius: 5px;
    background-color: #fac423;
    color: white;
    font-size: 16px;
    cursor: pointer;
}

.login-box button:hover {
    background-color: #00628c;
    transition: all ease 0.9s;
}

.toggle-btn {
    background-color: #008cba;
}

.toggle-btn:hover {
    background-color: #007bb5;
}

.forgot-password {
    display: block;
    margin-top: 10px;
    color: #007bb5;
    text-decoration: none;
}

.forgot-password:hover {
    text-decoration: underline;
}

@media (max-width: 600px) {
    .login-box {
        width: 90%;
    }
}
</style>
