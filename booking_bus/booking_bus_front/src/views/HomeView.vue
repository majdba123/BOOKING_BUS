<template>
    <div class="login-container">
        <form>
            <h2>Login</h2>
            <div class="input-container">
                <input
                    type="text"
                    v-model="inputText"
                    @focus="onFocus"
                    @blur="onBlur"
                    required
                />
                <span :class="{ active: inputText, moving: isMoving }"
                    >Enter Email</span
                >
            </div>
            <div class="input-container">
                <input
                    type="text"
                    v-model="password"
                    @focus="onFocus"
                    required
                />
                <span :class="{ active: inputText, moving: isMoving }"
                    >Enter Password</span
                >
            </div>

            <button type="button" class="admin" @click="login">Login</button>
            <!-- <button type="button" @click="login" class="company">
                Login Comapny
            </button> -->
        </form>
    </div>
</template>

<script>
import axios from "axios";
import router from "@/router";

export default {
    name: "HomeView",
    data() {
        return {
            email: "",
            password: "",
            inputText: "",
            isMoving: false,
        };
    },
    methods: {
        login() {
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/login",
                data: {
                    email: this.inputText,
                    password: this.password,
                },
            })
                .then((response) => {
                    if (response.status == 200) {
                        console.log(response);
                        window.alert("تسجيل الدخول ناجح");
                        window.localStorage.setItem(
                            "access_token",
                            response.data.access_token
                        );
                    }
                    if (response.data.type_user == "admin") {
                        router.push("/AdminPage");
                    } else if (response.data.type_user == "company") {
                        router.push("/CompanyPage");
                    } else router.push("/");
                })
                .catch((error) => {
                    window.alert("البريد الإلكتروني أو كلمة المرور غير صحيحة");
                    console.log(error);
                });
        },
        onFocus() {
            this.isMoving = true;
        },
        onBlur() {
            if (this.inputText === "") {
                this.isMoving = false;
            }
        },
    },
};
</script>

<style scoped>
.input-container {
    position: relative;
}

.input-container input {
    padding: 10px;
    border: none;
    background-color: transparent;
}

.input-container span {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    left: 15px;
    color: #aaa;
    pointer-events: none;
    transition: top 0.3s, font-size 0.3s, line-height 0.3s;
    line-height: 1;
}

.input-container span.moving {
    animation: movePlaceholder 0.5s forwards;
}

@keyframes movePlaceholder {
    from {
        top: 50%;
        font-size: inherit;
        line-height: inherit;
    }
    to {
        top: 10px;
        font-size: 12px;
        line-height: 1;
        background-color: white;
    }
}

.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f0f0f0;
}

form {
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    text-align: center;
    width: 300px;
}

h2 {
    margin-bottom: 20px;
    color: #000000;
}

input[type="text"],
input[type="password"] {
    width: 90%;
    padding: 10px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 5px;
    color: #000;
}

button {
    padding: 10px 20px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    width: 100%;
    margin-top: 10px;
}
.company {
    background-color: #db3604;
}
</style>
