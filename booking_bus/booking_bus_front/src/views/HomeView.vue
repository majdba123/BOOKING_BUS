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

                <button type="submit" :disabled="!formIsValid || isLoading">
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

        <!-- Animation Container -->
        <div v-if="isLoading" class="loading-overlay">
            <div class="loading-animation" ref="lottieContainer"></div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import router from "@/router";
import anime from "animejs";
import lottie from "lottie-web";
import { useToast } from "vue-toastification";

export default {
    name: "HomeView",
    setup() {
        const toast = useToast();
        return { toast };
    },
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
            isLoading: false,
            lottieAnimation: null,
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
        startLoadingAnimation() {
            this.isLoading = true;
            this.$nextTick(() => {
                if (this.$refs.lottieContainer) {
                    this.lottieAnimation = lottie.loadAnimation({
                        container: this.$refs.lottieContainer,
                        renderer: "svg",
                        loop: true,
                        autoplay: true,
                        animationData: require("@/assets/ani/Animation.json"),
                    });
                } else {
                    console.error("Lottie container is not available.");
                }
            });
        },
        stopLoadingAnimation() {
            console.log("Stopping loading animation");
            this.isLoading = false;
            if (this.lottieAnimation) {
                this.lottieAnimation.stop();
                this.lottieAnimation.destroy();
                this.lottieAnimation = null;
            }
        },

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
                this.errors.email = "";
                this.success.email = "";
            }
            this.updateFormValidity();
        },
        validatePassword() {
            if (this.password) {
                if (this.password.length < 8) {
                    this.errors.password =
                        "Password must be at least 8 characters.";
                    this.success.password = "";
                } else {
                    this.errors.password = "";
                    this.success.password = "Password looks good!";
                    this.clearSuccessMessage("password");
                }
            } else {
                this.errors.password = "";
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
                this.errors.username = "";
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
                this.startLoadingAnimation();
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
                        this.toast.error("Error during registration");
                        console.log(error);
                    })
                    .finally(() => {
                        this.stopLoadingAnimation();
                    });
            }
        },
        login() {
            if (this.validateForm()) {
                this.startLoadingAnimation();
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
                        this.toast.error("Invalid email or password");
                        console.log(error);
                    })
                    .finally(() => {
                        this.stopLoadingAnimation();
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
};
</script>

<style scoped>
.login-container {
    display: flex;
    align-items: center;
    height: 100vh;
    background: url("@/assets/buz.jpeg") no-repeat center center;
    background-size: cover;
    position: relative;
    padding: 20px;
}

.login-box {
    background: rgba(255, 255, 255, 0.5);
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

.success {
    color: green;
    font-size: 14px;
    margin-top: 4px;
    margin-bottom: 10px;
    display: block;
    opacity: 1;
    transition: opacity 2s ease-out;
}
.success.hide {
    opacity: 0;
}

.error {
    color: red;
    font-size: 14px;
    margin-top: 4px;
    margin-bottom: 10px;
    display: block;
    opacity: 1;
    transition: opacity 2s ease-out;
}

.error.hide {
    opacity: 0;
}

.loading-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    backdrop-filter: blur(5px);
}

.loading-animation {
    width: 200px;
    height: 200px;
}

/* Media queries for responsiveness */
@media (max-width: 768px) {
    .login-box {
        padding: 15px;
        margin-left: 0;
        max-width: 300px;
    }

    .login-box h1 {
        font-size: 24px;
    }

    .login-box input {
        padding: 8px;
        font-size: 14px;
    }

    .login-box button {
        padding: 8px;
        font-size: 14px;
    }

    .loading-animation {
        width: 150px;
        height: 150px;
    }
}

@media (max-width: 480px) {
    .login-container {
        padding: 10px;
        margin-left: 0;
    }

    .login-box {
        padding: 10px;
        max-width: 280px;
    }

    .login-box h1 {
        font-size: 20px;
    }

    .login-box input {
        padding: 7px;
        font-size: 13px;
    }

    .login-box button {
        padding: 7px;
        font-size: 13px;
    }

    .loading-animation {
        width: 120px;
        height: 120px;
    }
}
</style>
