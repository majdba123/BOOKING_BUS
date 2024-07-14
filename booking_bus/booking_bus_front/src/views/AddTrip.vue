<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="title">ADD Trip</div>
            <div class="contentt2">
                <div class="box">
                    <div class="field">
                        <span>Path</span>
                        <select v-model="path" class="input">
                            <option
                                v-for="(pathItem, index) in paths"
                                :key="index"
                                :value="pathItem.id"
                            >
                                {{ pathItem.from }} >>
                                {{ pathItem.to }}
                            </option>
                            <option value="path2">Path 2</option>
                            <!-- Add more paths as needed -->
                        </select>
                    </div>
                    <div class="field">
                        <span>Price</span>
                        <input
                            type="text"
                            class="input"
                            placeholder="Enter Price"
                            v-model="price"
                        />
                    </div>
                    <div class="field">
                        <span>Area</span>
                        <select v-model="area" class="input">
                            <option
                                v-for="(area, index) in Government"
                                :key="index"
                                :value="area.id"
                            >
                                {{ area.name }}
                            </option>
                            <!-- Add more areas as needed -->
                        </select>
                    </div>
                    <div class="field">
                        <span>Search Break Areas</span>
                        <select
                            v-model="search_break_areas"
                            class="input"
                            multiple
                        >
                            <option
                                v-for="(breakItem, index) in breaks"
                                :key="index"
                                :value="breakItem.id"
                            >
                                {{ breakItem.name }}
                            </option>
                        </select>
                    </div>
                    <div class="field">
                        <span>Bus</span>
                        <select v-model="bus" class="input">
                            <option
                                v-for="(bus, index) in buses"
                                :key="index"
                                value="bus1"
                            >
                                {{ bus.number_bus }}
                            </option>
                            <!-- Add more buses as needed -->
                        </select>
                    </div>
                    <div class="field">
                        <span>Type</span>
                        <div class="radio-group">
                            <input
                                type="radio"
                                id="all"
                                value="all"
                                v-model="type"
                            />
                            <label for="all">All</label>
                            <input
                                type="radio"
                                id="going"
                                value="going"
                                v-model="type"
                            />
                            <label for="going">Going</label>
                        </div>
                    </div>
                    <div class="field">
                        <span>Date</span>
                        <input type="date" class="input" v-model="date" />
                    </div>
                    <div class="field">
                        <span>Start Time</span>
                        <input type="time" class="input" v-model="start_time" />
                    </div>
                    <div class="field">
                        <span>End Time</span>
                        <input type="time" class="input" v-model="end_time" />
                    </div>
                </div>
                <button class="Button" @click="AddTrip">ADD</button>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import NavBarCompany from "@/components/NavBarCompany.vue";

export default {
    components: { NavBarCompany },

    name: "AddTrip",
    data() {
        return {
            paths: [],
            Government: [],
            buses: [],
            path: "",
            price: "",
            area: "",
            search_break_areas: "",
            bus: "",
            type: "",
            date: "",
            start_time: "",
            end_time: "",
        };
    },
    mounted() {
        this.fetchPaths();
        this.fetchGovernment();
        this.fetchBuses();
        this.fetchBreak();
    },
    methods: {
        fetchBreak() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "127.0.0.1:8000/api/admin/all_breaks/+",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.buses = response.data;
                    console.log(this.buses);
                })
                .catch((error) => {
                    window.alert("Error getting buses");
                    console.error(error);
                });
        },
        fetchBuses() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.buses = response.data;
                    console.log(this.buses);
                })
                .catch((error) => {
                    window.alert("Error getting buses");
                    console.error(error);
                });
        },
        fetchGovernment() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Government = response.data;
                    console.log(this.Government);
                })
                .catch((error) => {
                    window.alert("Error getting Government");
                    console.error(error);
                });
        },
        fetchPaths() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_path",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.paths = response.data;
                    console.log(this.path);
                })
                .catch((error) => {
                    window.alert("Error getting paths");
                    console.error(error);
                });
        },
        AddTrip() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/store_trip",
                data: {
                    path_id: this.path,
                    price: this.price,
                    area: this.area,
                    search_break_areas: this.search_break_areas,
                    bus: this.bus,
                    type: this.type,
                    date: this.date,
                    start_time: this.start_time,
                    end_time: this.end_time,
                },
                headers: { Authorization: `Bearer ${token}` },
            })
                .then((response) => {
                    console.log(response);
                    window.alert("Complete ADD");
                })
                .catch((error) => {
                    window.alert("ERROR ADD");
                    console.log(error);
                    console.log(this.area);
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
    flex-direction: column;
    margin: 30px;
    padding: 20px;
    background-color: white;
    border-radius: 15px;
    text-align: center;
    font-size: 20px;
    gap: 20px;
}
.field span {
    color: black;
    display: block;
    margin: 5px 0;
}
.input {
    width: 100%;
    color: black;
    height: 30px;
    border-radius: 5px;
    border: 1px solid gray;
    font-size: 16px;
    text-align: center;
}
.input::placeholder {
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
.radio-group {
    display: flex;
    justify-content: center;
    gap: 20px;
}
.radio-group input {
    margin-right: 5px;
}
</style>
