<template>
    <div class="containers">
        <div class="content">
            <div class="form-container">
                <form class="profile-form" @submit.prevent="storeCompanyInfo">
                    <div class="form-group">
                        <label for="name">Company Name</label>
                        <input
                            type="text"
                            id="name"
                            placeholder="Enter Company Name"
                            v-model="company.name"
                        />
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input
                            type="email"
                            id="email"
                            placeholder="Enter Email"
                            v-model="company.email"
                        />
                    </div>
                    <div class="form-group">
                        <label for="city">City</label>
                        <input
                            type="text"
                            id="city"
                            placeholder="Enter City"
                            v-model="company.city"
                        />
                    </div>
                    <div class="form-group">
                        <label for="area">Area</label>
                        <input
                            type="text"
                            id="area"
                            placeholder="Enter Area"
                            v-model="company.area"
                        />
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input
                            type="tel"
                            id="phone"
                            placeholder="Enter Phone Number"
                            v-model="company.phone"
                        />
                    </div>
                    <div class="form-group">
                        <label for="logo">Company Logo</label>
                        <input
                            type="file"
                            id="logo"
                            @change="handleLogoUpload"
                            accept="image/*"
                        />
                    </div>
                    <div class="submit-btn">
                        <button type="submit">Save Profile</button>
                        <button type="button" @click="modifyCompanyInfo">
                            Update Profile
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
    name: "ProfileCompanys",
    data() {
        return {
            company: {
                name: "",
                email: "",
                city: "",
                area: "",
                phone: "",
                logo: null,
            },
        };
    },
    mounted() {
        this.fetchCompanyInfo();
        this.fetchCompanyAddress();
    },
    methods: {
        fetchCompanyInfo() {
            const access_token = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/my_info", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.company.name = response.data.name;
                    this.company.email = response.data.email;
                    this.company.phone = response.data.phone;
                    // Assuming the logo URL is included in the response
                    this.company.logo = response.data.logo;
                })
                .catch((error) => {
                    console.error(
                        "There was an error fetching the company info:",
                        error
                    );
                });
        },
        fetchCompanyAddress() {
            const access_token = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/all_my_address", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    if (response.data.length > 0) {
                        // Assuming the response contains an array of addresses
                        const address = response.data[0]; // Get the first address
                        this.company.city = address.city;
                        this.company.area = address.area;
                    }
                })
                .catch((error) => {
                    console.error(
                        "There was an error fetching the company address:",
                        error
                    );
                });
        },
        storeCompanyInfo() {
            const formData = this.createFormData();
            const access_token = window.localStorage.getItem("access_token");
            const toast = useToast();

            // Update address separately
            axios
                .post(
                    `http://127.0.0.1:8000/api/company/store_address?city=${this.company.city}&area=${this.company.area}`,
                    {},
                    {
                        headers: {
                            Authorization: `Bearer ${access_token}`,
                        },
                    }
                )
                .then(() => {
                    axios
                        .post(
                            "http://127.0.0.1:8000/api/company/store_profile_info",
                            formData,
                            {
                                headers: {
                                    Authorization: `Bearer ${access_token}`,
                                    "Content-Type": "multipart/form-data",
                                },
                            }
                        )
                        .then(() => {
                            toast.success("Company info stored successfully!");
                        })
                        .catch((error) => {
                            console.error(
                                "There was an error storing the company info:",
                                error.response ? error.response.data : error
                            );
                            toast.error(
                                "Error storing company info: " +
                                    (error.response
                                        ? error.response.data.detail
                                        : "Unknown error")
                            );
                        });
                })
                .catch((error) => {
                    console.error(
                        "There was an error updating the address:",
                        error.response ? error.response.data : error
                    );
                    toast.error(
                        "Error updating address: " +
                            (error.response
                                ? error.response.data.detail
                                : "Unknown error")
                    );
                });
        },
        modifyCompanyInfo() {
            const formData = this.createFormData();
            const access_token = window.localStorage.getItem("access_token");
            const toast = useToast();

            // Update address separately
            axios
                .put(
                    `http://127.0.0.1:8000/api/company/update_address/1?city=${this.company.city}&area=${this.company.area}`,
                    {},
                    {
                        headers: {
                            Authorization: `Bearer ${access_token}`,
                        },
                    }
                )
                .then(() => {
                    axios
                        .post(
                            "http://127.0.0.1:8000/api/company/update_profile_info",
                            formData,
                            {
                                headers: {
                                    Authorization: `Bearer ${access_token}`,
                                    "Content-Type": "multipart/form-data",
                                },
                            }
                        )
                        .then((response) => {
                            toast.success(
                                "Company info modified successfully!"
                            );
                            console.log(response);
                        })
                        .catch((error) => {
                            console.error(
                                "There was an error modifying the company info:",
                                error.response ? error.response.data : error
                            );
                            toast.error(
                                "Error modifying company info: " +
                                    (error.response
                                        ? error.response.data.detail
                                        : "Unknown error")
                            );
                        });
                })
                .catch((error) => {
                    console.error(
                        "There was an error updating the address:",
                        error.response ? error.response.data : error
                    );
                    toast.error(
                        "Error updating address: " +
                            (error.response
                                ? error.response.data.detail
                                : "Unknown error")
                    );
                });
        },
        handleLogoUpload(event) {
            this.company.logo = event.target.files[0];
        },
        createFormData() {
            const formData = new FormData();
            formData.append("name", this.company.name);
            formData.append("email", this.company.email);
            formData.append("phone", this.company.phone);
            if (this.company.logo) {
                formData.append("image", this.company.logo); // Ensure the key name is 'image'
            }

            console.log([...formData]); // Print formData content to console for debugging
            return formData;
        },
    },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap");

:root {
    --clr-primary: #7380ec;
    --clr-danger: #ff7782;
    --clr-success: #41f1b6;
    --clr-white: #fff;
    --clr-info-dark: #7d8da1;
    --clr-info-light: #e4e9f7;
    --clr-dark: #363949;
    --clr-warning: #ffbb55;
    --clr-light: rgba(132, 139, 200, 0.18);
    --clr-primary-variant: #111e88;
    --clr-dark-variant: #677483;
    --clr-color-background: #f6f6f9;
    --card-border-radius: 2rem;
    --border-radius-1: 0.4rem;
    --border-radius-2: 0.8rem;
    --border-radius-3: 1.2rem;
    --card-padding: 1.8rem;
    --padding-1: 1.2rem;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

.containers {
    padding: 20px;
    background: #f6f6f9;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
}

.header {
    width: 100%;
    text-align: center;
    margin-bottom: 20px;
}

.content {
    width: 100%;
    max-width: 800px;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 0 auto;
}

.form-container {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: var(--box-shadow);
    width: 100%;
}

.profile-form {
    display: flex;
    flex-direction: column;
    gap: 15px;
    width: 100%;
}

.form-group {
    display: flex;
    flex-direction: column;
}

label {
    margin-bottom: 5px;
    font-weight: 500;
    color: #363949;
}

input,
select,
textarea {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    width: 100%;
    font-size: 1rem;
}

input:focus,
select:focus,
textarea:focus {
    border-color: #007bff;
}

.submit-btn {
    text-align: center;
}

.submit-btn button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    margin-right: 10px;
}

.submit-btn button:hover {
    background-color: #0056b3;
}

/* Media Queries for Responsive Design */
@media screen and (max-width: 768px) {
    .container {
        padding: 10px;
    }

    .content {
        width: 100%;
        max-width: 100%;
        margin: 0;
        padding: 0 10px;
    }

    .form-container {
        padding: 15px;
    }

    .profile-form {
        gap: 10px;
    }

    .form-group {
        margin-bottom: 10px;
    }

    input,
    select,
    textarea {
        padding: 8px;
        font-size: 0.9rem;
    }

    .submit-btn button {
        padding: 8px 16px;
        font-size: 0.9rem;
    }
}
</style>
