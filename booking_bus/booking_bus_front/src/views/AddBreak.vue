<template>
    <div class="main-content">
        <NavBar />
        <div class="content">
            <div class="title">ADD BREAK</div>
            <div class="contentt2">
                <div class="box">
                    <div class="email">
                        <span>Name Break</span>
                        <input
                            type="text"
                            placeholder="Enter Name Break"
                            class="input"
                            v-model="name"
                        />
                    </div>
                </div>
                <button class="Button" @click="AddBreak">ADD</button>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import NavBar from "@/components/NavBar.vue";

export default {
    components: { NavBar },

    name: "AddBreak",
    data() {
        return {
            name: "",
        };
    },
    methods: {
        AddBreak() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "127.0.0.1:8000/api/admin/store_breaks/" + "5",
                data: {
                    name: this.name,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    console.log(response);
                    window.alert("Complete ADD");
                })
                .catch((error) => {
                    window.alert("ERROR ADD");
                    console.error(error);
                });
        },
    },
};
</script>

<style scoped lang="scss">
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
    justify-content: center;
}
.email span {
    color: black;
    display: block;
    margin: 15px;
}
.input::placeholder {
    text-align: center;
}
input[type="text"] {
    width: 100%;
    color: black;
    height: 30%;
    border-radius: 5px;
    border: 1px solid gray;
    font-size: 16px;
    text-align: center;
}
input:focus {
    box-shadow: 0 0 5px red;
}
.Button {
    text-align: center;
    align-items: center;
    background-color: #176b87;
    padding: 10px 40px;
    border-radius: 15px;
    border: 1px solid gray;
}
</style>
