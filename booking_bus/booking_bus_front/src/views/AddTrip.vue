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
                                {{ pathItem.from }} >> {{ pathItem.to }}
                            </option>
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
                        <select
                            v-model="area"
                            class="input"
                            @change="fetchBreak"
                        >
                            <option
                                v-for="(areaItem, index) in Government"
                                :key="index"
                                :value="areaItem.id"
                            >
                                {{ areaItem.name }}
                            </option>
                        </select>
                    </div>
                    <div class="field">
                        <span>Search Break Areas</span>
                        <select
                            v-model="search_break_areas"
                            class="input multi-select"
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
                        <div
                            v-for="(bus, index) in buses"
                            :key="index"
                            class="bus-field"
                        >
                            <select v-model="bus.bus_id" class="input">
                                <option
                                    v-for="(busItem, i) in availableBuses"
                                    :key="i"
                                    :value="busItem.id"
                                >
                                    {{ busItem.number_bus }}
                                </option>
                            </select>
                            <span>Type</span>

                            <select v-model="bus.type" class="input">
                                <option value="all">All</option>
                                <option value="going">Going</option>
                            </select>
                            <span>Start Time</span>

                            <input
                                v-model="bus.start_time"
                                type="time"
                                class="input"
                            />
                            <span>End Time</span>

                            <input
                                v-model="bus.end_time"
                                type="time"
                                class="input"
                            />
                            <button
                                @click="removeBus(index)"
                                class="Button remove-bus-button"
                            >
                                Remove Bus
                            </button>
                        </div>
                        <button @click="addBus" class="Button add-bus-button">
                            Add Another Bus
                        </button>
                    </div>
                    <div class="field">
                        <span>Date</span>
                        <input type="date" class="input" v-model="date" />
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
            date: "",
            paths: [],
            Government: [],
            availableBuses: [], // Added for fetching available buses
            breaks: [],
            path: "",
            price: "",
            area: "",
            search_break_areas: [],
            buses: [
                {
                    bus_id: "",
                    type: "all",
                    start_time: "",
                    end_time: "",
                    date: "",
                },
            ], // Initialize with one empty bus
            start_time: "",
            end_time: "",
        };
    },
    mounted() {
        this.fetchPaths();
        this.fetchGovernment();
        this.fetchAvailableBuses(); // Fetch available buses
    },
    methods: {
        fetchBreak() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/company/all_breaks/${this.area}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.breaks = response.data;
                })
                .catch((error) => {
                    window.alert("Error getting breaks");
                    console.error(error);
                });
        },
        fetchAvailableBuses() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/all_bus",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.availableBuses = response.data;
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
                })
                .catch((error) => {
                    window.alert("Error getting paths");
                    console.error(error);
                });
        },
        addBus() {
            this.buses.push({
                bus_id: "",
                type: "",
                start_time: "",
                end_time: "",
                date: "",
            });
        },
        removeBus(index) {
            this.buses.splice(index, 1);
        },
        AddTrip() {
            const token = window.localStorage.getItem("access_token");

            // تحويل البيانات إلى الصيغة المطلوبة للـ API
            const busIds = this.buses.map((bus) => ({
                bus_id: bus.bus_id,
                type: bus.type,
                start_time: bus.start_time,
                end_time: bus.end_time,
                date: this.date, // إضافة التاريخ هنا
            }));

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/store_trip",
                data: {
                    path_id: this.path,
                    price: this.price,
                    area: this.area,
                    breaks_ids: this.search_break_areas,
                    bus_ids: busIds,
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
