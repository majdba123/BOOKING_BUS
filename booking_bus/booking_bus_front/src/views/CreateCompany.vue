<template>
    <div class="main-content">
        <NavBar />
        <div class="content">
            <div class="title">Add Company</div>
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
                <button class="Button" @click="CreateCompany">Create</button>
            </div>
        </div>
    </div>
</template>

<script>
import NavBar from "@/components/NavBar.vue";
import axios from "axios";

export default {
    name: "CreateCompany",
    components: { NavBar },
    data() {
        return {
            name: "",
            email: "",
            password: "",
        };
    },
    methods: {
        CreateCompany() {
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/register/company",
                data: {
                    name: this.name,
                    email: this.email,
                    password: this.password,
                },
            })
                .then((response) => {
                    if (response.status == 200) {
                        console.log(response);
                        window.alert("تم اضافة حساب شركة");
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
<style lang="scss" scoped>
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
