<template>
    <div class="login-container">
        <form>
            <h2>Login</h2>
            <input type="text" v-model="email" placeholder="Email" required />
            <input
                type="password"
                v-model="password"
                placeholder="password "
                required
            />
            <button type="button" class="admin" @click="login">
                Login Admin
            </button>
            <button type="button" class="company">Login Comapny</button>
        </form>
    </div>
</template>

<script>
import axios from "axios";

export default {
    name: "LoginForm",
    data() {
        return {
            email: "",
            password: "",
        };
    },
    methods: {
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
                    if (response.status == 200) {
                        console.log(response);
                        window.alert("تسجيل الدخول ناجح");
                        window.localStorage.setItem(
                            "access_token",
                            response.data.access_token
                        );
                    }
                })
                .catch((error) => {
                    window.alert("البريد الإلكتروني أو كلمة المرور غير صحيحة");
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
