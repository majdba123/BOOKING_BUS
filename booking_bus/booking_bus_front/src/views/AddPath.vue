<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="title">Add Company</div>
            <div class="contentt2">
                <div class="box">
                    <div class="email">
                        <span>Start Path</span
                        ><input
                            type="text"
                            placeholder="Inter Start Path"
                            class="input"
                            v-model="StartPath"
                        />
                    </div>
                    <div class="username">
                        <span>TO</span>
                    </div>
                    <div class="password">
                        <span>End Path</span
                        ><input
                            type="text"
                            class="input"
                            placeholder="End Path"
                            v-model="EndPath"
                        />
                    </div>
                </div>
                <button class="Button" @click="AddPath">Add</button>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    name: "AddPath",
    data() {
        return {
            StartPath: "",
            EndPath: "",
        };
    },
    methods: {
        AddPath() {
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/register/company",
                data: {
                    StartPath: this.StartPath,
                    EndPath: this.EndPath,
                },
            })
                .then((response) => {
                    if (response.status == 200) {
                        console.log(response);
                        window.alert("Complete ADD");
                    }
                })
                .catch((error) => {
                    window.alert("ERROR ADD");
                    console.log(error);
                });
        },
    },
};
</script>
<style lang="scss">
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
