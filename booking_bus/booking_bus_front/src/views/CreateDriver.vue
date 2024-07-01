<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="title">Add Driver</div>
            <div class="contentt2">
                <div class="box">
                    <div class="email">
                        <span>Email</span
                        ><input
                            type="email"
                            placeholder="Inter Email"
                            class="input"
                            v-model="email"
                        />
                    </div>
                    <div class="username">
                        <span>Username</span
                        ><input
                            type="text"
                            class="input"
                            placeholder="Inter Username"
                            v-model="name"
                        />
                    </div>
                    <div class="password">
                        <span>Password</span
                        ><input
                            type="password"
                            class="input"
                            placeholder="Inter Password"
                            v-model="password"
                        />
                    </div>
                </div>
                <button class="Button" @click="CreateDriver">Create</button>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";
import axios from "axios";

export default {
    name: "CreateDriver",
    components: { NavBarCompany },
    data() {
        return {
            name: "",
            email: "",
            password: "",
        };
    },
    methods: {
        CreateDriver() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/register/driver",
                data: {
                    name: this.name,
                    email: this.email,
                    password: this.password,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    if (response.status == 200) {
                        console.log(response);
                        window.alert("تم اضافة حساب سائق");
                    }
                })
                .catch((error) => {
                    window.alert("البريد مسجل سابقا ");
                    console.log(error);
                });
        },
    },
};
</script>
<style lang="scss">
* {
}
.main-content {
    display: flex;
    width: 100%;
}
.content {
    display: block;
}
.contentt2 {
    display: block;
    text-align: center;
}
.title {
    margin: 30px;
    padding: 20px;
    background-color: #176b87;
    border-radius: 15px;
    text-align: center;
    font-size: 26px;
}
.box {
    display: flex;
    margin: 30px;
    padding: 20px;
    background-color: white;
    border-radius: 15px;
    text-align: center;
    font-size: 20px;
    justify-content: space-between;
}
.email span,
.password span,
.username span {
    color: black;
    display: block;
    margin: 15px;
}
input[type="text"],
input[type="password"],
input[type="email"] {
    width: 100%;
    color: black;
    height: 30%;
    border-radius: 5px;
    border: 1px solid gray;
    font-size: 16px;
}
input:focus {
    box-shadow: 0 0 5px red;
}
.Button {
    text-align: center;
    align-items: center;
    background-color: #176b87;
    padding: 10px 40px 10px 40px;
    border-radius: 15px;
    border: 1px solid gray;
}
</style>
