<template>
    <div class="main-content">
        <NavBarUser />
        <div class="content">
            <div class="title">ADD Private Trip</div>
            <div class="contentt2">
                <div class="box">
                    <div class="field">
                        <span>From</span>
                        <input
                            type="text"
                            v-model="from"
                            placeholder="Enter From"
                            class="input"
                        />
                    </div>
                    <div class="field">
                        <span>To</span>
                        <input
                            type="text"
                            v-model="to"
                            placeholder="Enter To"
                            class="input"
                        />
                    </div>
                    <div class="field">
                        <span>Date</span>
                        <input type="date" class="input" v-model="date" />
                    </div>

                    <div class="field">
                        <span>Start Time</span>
                        <input v-model="start_time" type="time" class="input" />
                    </div>
                </div>
                <button class="Button" @click="AddPrivateTrip">ADD Trip</button>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import NavBarUser from "@/components/NavBarUser.vue";

export default {
    components: { NavBarUser },

    name: "AddTrip",
    data() {
        return {
            from: "",
            to: "",
            date: "",
            start_time: "",
        };
    },

    methods: {
        AddPrivateTrip() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/user/store_private_trip",
                data: {
                    from: this.from,
                    to: this.to,
                    date: this.date,
                    start_time: this.start_time,
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
                    console.log(this.date);
                });
        },
    },
};
</script>

<style scoped lang="scss">
.main-content {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    min-height: 100vh;
    background-color: #f0f4f8;
}

.content {
    display: block;
    width: 100%;
    max-width: 800px; /* عرض النموذج بحد أقصى */
    padding: 20px;
}

.contentt2 {
    display: block;
    text-align: center;
    padding: 20px;
}

.title {
    margin: 30px 0;
    padding: 20px;
    background-color: #176b87;
    border-radius: 15px;
    color: white;
    font-size: 26px;
    font-weight: bold;
}

.box {
    display: flex;
    flex-direction: column;
    margin: 0 auto; /* توسيط النموذج أفقيًا */
    padding: 20px;
    background-color: white;
    border-radius: 15px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    text-align: center;
    font-size: 18px;
    gap: 20px;
    max-width: 100%; /* يضمن عدم تجاوز النموذج للحاوية */
}

.field {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.field span {
    color: #333;
    font-weight: 500;
    font-size: 16px;
}

.input {
    width: 100%;
    height: 40px;
    border-radius: 5px;
    border: 1px solid #ddd;
    padding: 0 12px;
    font-size: 16px;
    background-color: #fff;
    box-sizing: border-box;
    transition: border-color 0.3s ease;
}

.input::placeholder {
    color: #bbb;
}

.input:focus {
    border-color: #007bff;
    outline: none;
}

.multi-select {
    height: auto;
    max-height: 100px;
    overflow-y: auto;
}

.Button {
    background-color: #007bff;
    color: #fff;
    padding: 10px 20px;
    border-radius: 5px;
    border: none;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-top: 20px; /* إضافة مسافة بين الأزرار */
}

.Button:hover {
    background-color: #0056b3;
}

.Button:focus {
    outline: none;
}

.remove-bus-button {
    background-color: #dc3545;
}

.remove-bus-button:hover {
    background-color: #c82333;
}

.add-bus-button {
    margin-top: 10px;
    background-color: #28a745;
}

.add-bus-button:hover {
    background-color: #218838;
}

.bus-field {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-bottom: 10px;
}
</style>
