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
                    <div class="dropdown">
                        <button @click="toggleDropdown" class="dropbtn">
                            Select Government
                        </button>
                        <div
                            :class="{
                                'dropdown-content': true,
                                show: dropdownOpen,
                            }"
                        >
                            <input
                                type="text"
                                placeholder="Search.."
                                @keyup="filterFunction"
                                ref="myInput"
                            />
                            <a
                                v-for="(link, index) in filteredList"
                                :key="index"
                                @click="selectGovernment(link)"
                            >
                                {{ link.name }}
                            </a>
                        </div>
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
            dropdownOpen: false,
            links: [],
            filteredList: [],
            selectedGovernment: null,
        };
    },

    methods: {
        toggleDropdown() {
            this.dropdownOpen = !this.dropdownOpen;
            this.filteredList = this.links;
        },
        filterFunction() {
            const input = this.$refs.myInput.value.toUpperCase();
            this.filteredList = this.links.filter((link) =>
                link.name.toUpperCase().includes(input)
            );
        },
        selectGovernment(link) {
            this.selectedGovernment = link.id;
            this.dropdownOpen = false;
        },
        fetchGovernment() {
            const access_token = window.localStorage.getItem("access_token");

            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/admin/all_government",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.links = response.data;
                    console.log(this.links);
                })
                .catch((error) => {
                    window.alert("Error getting Government");
                    console.error(error);
                });
        },
        AddBreak() {
            if (!this.selectedGovernment) {
                window.alert("Please select a government.");
                return;
            }
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: `http://127.0.0.1:8000/api/admin/store_breaks/${this.selectedGovernment}`,
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
    mounted() {
        this.fetchGovernment();
    },
};
</script>

<style scoped>
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
    align-items: center;
    margin: 30px;
    padding: 20px;
    background-color: white;
    border-radius: 15px;
    text-align: center;
    font-size: 20px;
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

.dropbtn {
    background-color: #04aa6d;
    color: white;
    padding: 16px;
    font-size: 16px;
    border: none;
    cursor: pointer;
    border-radius: 20px;
}

.dropbtn:hover,
.dropbtn:focus {
    background-color: #3e8e41;
}

.dropdown {
    position: relative;
    display: inline-block;
    margin-top: 15px;
}

.dropdown-content {
    display: none;
    position: absolute;
    background-color: #f6f6f6;
    min-width: 230px;
    overflow: auto;
    border: 1px solid #ddd;
    z-index: 1;
}

.dropdown-content a {
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
}

.dropdown-content a:hover {
    background-color: #ddd;
}

.show {
    display: block;
}
</style>
