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
                    @input="validateUsername"
                    required
                />
                <span v-if="errors.username" class="error">{{
                    errors.username
                }}</span>
                <span v-if="success.username" class="success">{{
                    success.username
                }}</span>

                <input
                    type="text"
                    v-model="email"
                    placeholder="Email"
                    @input="validateEmail"
                    required
                />
                <span v-if="errors.email" class="error">{{
                    errors.email
                }}</span>
                <span v-if="success.email" class="success">{{
                    success.email
                }}</span>

                <input
                    type="password"
                    v-model="password"
                    placeholder="Password"
                    @input="validatePassword"
                    required
                />
                <span v-if="errors.password" class="error">{{
                    errors.password
                }}</span>
                <span v-if="success.password" class="success">{{
                    success.password
                }}</span>

                <button type="submit" :disabled="!formIsValid">
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
            errors: {},
            success: {},
            typingTimeouts: {
                email: null,
                password: null,
                username: null,
            },
            formIsValid: false,
        };
    },
    watch: {
        email() {
            this.validateEmail();
        },
        password() {
            this.validatePassword();
        },
        username() {
            if (!this.isLogin) {
                this.validateUsername();
            }
        },
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
        clearSuccessMessage(field) {
            if (this.typingTimeouts[field]) {
                clearTimeout(this.typingTimeouts[field]);
            }
            this.typingTimeouts[field] = setTimeout(() => {
                this.success[field] = "";
            }, 2000);
        },
        validateEmail() {
            if (this.email) {
                if (!this.validEmail(this.email)) {
                    this.errors.email = "Valid email required.";
                    this.success.email = "";
                } else {
                    this.errors.email = "";
                    this.success.email = "Email looks good!";
                    this.clearSuccessMessage("email");
                }
            } else {
                this.errors.email = "Email is required.";
                this.success.email = "";
            }
            this.updateFormValidity();
        },
        validatePassword() {
            if (this.password) {
                if (this.password.length < 6) {
                    this.errors.password =
                        "Password must be at least 6 characters.";
                    this.success.password = "";
                } else {
                    this.errors.password = "";
                    this.success.password = "Password looks good!";
                    this.clearSuccessMessage("password");
                }
            } else {
                this.errors.password = "Password is required.";
                this.success.password = "";
            }
            this.updateFormValidity();
        },
        validateUsername() {
            if (this.username) {
                this.errors.username = "";
                this.success.username = "Username looks good!";
                this.clearSuccessMessage("username");
            } else {
                this.errors.username = "Username is required.";
                this.success.username = "";
            }
            this.updateFormValidity();
        },
        updateFormValidity() {
            this.formIsValid = Object.keys(this.errors).every(
                (key) => !this.errors[key]
            );
        },
        validateForm() {
            this.validateEmail();
            this.validatePassword();
            if (!this.isLogin) {
                this.validateUsername();
            }
            return this.formIsValid;
        },
        validEmail(email) {
            const re = /\S+@\S+\.\S+/;
            return re.test(email);
        },
        register() {
            if (this.validateForm()) {
                axios
                    .post("http://127.0.0.1:8000/api/register", {
                        name: this.username,
                        email: this.email,
                        password: this.password,
                    })
                    .then((response) => {
                        if (response.status === 200) {
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
            }
        },
        login() {
            if (this.validateForm()) {
                axios
                    .post("http://127.0.0.1:8000/api/login", {
                        email: this.email,
                        password: this.password,
                    })
                    .then((response) => {
                        if (response.status === 200) {
                            window.localStorage.setItem(
                                "access_token",
                                response.data.access_token
                            );
                            const userType = response.data.type_user;
                            if (userType === "admin") {
                                router.push("/AdminPage");
                            } else if (userType === "company") {
                                router.push("/BookingLogin");
                            } else if (userType === "user") {
                                router.push("/UserPage");
                            } else {
                                router.push("/");
                            }
                        }
                    })
                    .catch((error) => {
                        alert("Invalid email or password");
                        console.log(error);
                    });
            }
        },
        toggleForm() {
            this.isLogin = !this.isLogin;
            this.email = "";
            this.password = "";
            this.username = "";
            this.errors = {};
            this.success = {};
            this.formIsValid = false;
            anime({
                targets: this.$refs.loginBox,
                translateY: [-50, 0],
                opacity: [0, 1],
                duration: 1000,
                easing: "easeOutExpo",
            });
        },
    },
    clearAllMessages() {
        this.errors = {};
        this.success = {};
        this.formIsValid = false;
    },
};
</script>

<style scoped>
.login-container {
    display: flex;
    align-items: center;
    height: 100vh;
    background: url("@/assets/buz.jpeg") no-repeat center center;
    background-size: cover;
}
.login-box {
    background: rgba(255, 255, 255, 0.7);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: center;
    width: 100%;
    max-width: 400px;
    opacity: 0;
    margin-left: 60px;
    margin-top: 10px;
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
.error {
    color: red;
    font-size: 14px;
    margin-top: 4px;
    margin-bottom: 10px;
    display: block;
}
.success {
    color: green;
    font-size: 14px;
    margin-top: 4px;
    margin-bottom: 10px;
    display: block;
}
@media (max-width: 600px) {
    .login-box {
        width: 90%;
        margin: 0;
    }
    .login-container {
        display: flex;
        align-items: center;
        justify-content: center;
    }
}
</style>
