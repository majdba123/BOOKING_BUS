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
                    <div class="form-group image-upload">
                        <label for="logo">Company Logo</label>
                        <div class="image-upload-container">
                            <input
                                type="file"
                                id="logo"
                                @change="handleLogoUpload"
                                accept="image/*"
                            />
                            <img
                                v-if="company.logoURL"
                                :src="company.logoURL"
                                alt="Company Logo"
                                class="logo-image"
                            />
                        </div>
                    </div>
                    <div class="submit-btn">
                        <button v-if="!isDataFilled" type="submit">
                            Save Profile
                        </button>
                        <button
                            v-if="isDataFilled"
                            type="button"
                            @click="modifyCompanyInfo"
                        >
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
                id: null,
                name: "",
                email: "",
                city: "",
                area: "",
                phone: "",
                logo: null,
                logoURL: null,
                addressId: null,
            },
            isDataFilled: false,
        };
    },

    mounted() {
        this.isDataFilled = false;
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
                    this.company.id = response.data.id;
                    this.company.name = response.data.name;
                    this.company.email = response.data.email;
                    this.company.phone = response.data.phoneNumber;
                    this.company.logoURL = response.data.profile_image;
                    this.checkDataFilled();
                })
                .catch((error) => {
                    console.error(
                        "There was an error fetching the company info:",
                        error
                    );
                });
        },
        checkDataFilled() {
            this.isDataFilled =
                this.company.name !== "" &&
                this.company.email !== "" &&
                this.company.city !== "" &&
                this.company.area !== "" &&
                this.company.phone !== "" &&
                this.company.logoURL !== null;
        },
        fetchCompanyAddress() {
            const access_token = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/all_my_address", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    if (response.data.length > 0) {
                        const address = response.data[0];
                        this.company.city = address.city;
                        this.company.area = address.area;
                        this.company.addressId = address.id;
                        this.checkDataFilled();
                    } else {
                        console.error("No address found.");
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

            axios
                .post(
                    `http://127.0.0.1:8000/api/company/store_address?city=${this.company.city}&area=${this.company.area}`,
                    {},
                    { headers: { Authorization: `Bearer ${access_token}` } }
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
                                "Error storing company info:",
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
                        "Error updating address:",
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
            if (!this.company.city || !this.company.area) {
                console.error("Address data is missing.");
                return;
            }

            const formData = this.createFormData();
            const access_token = window.localStorage.getItem("access_token");
            const toast = useToast();

            axios
                .put(
                    `http://127.0.0.1:8000/api/company/update_address/${this.company.addressId}?city=${this.company.city}&area=${this.company.area}`,
                    {},
                    { headers: { Authorization: `Bearer ${access_token}` } }
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
                        .then(() => {
                            toast.success(
                                "Company info modified successfully!"
                            );
                        })
                        .catch((error) => {
                            console.error(
                                "Error modifying company info:",
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
                        "Error updating address:",
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
            const reader = new FileReader();
            reader.onload = (e) => {
                this.company.logoURL = e.target.result;
            };
            reader.readAsDataURL(this.company.logo);
        },
        createFormData() {
            const formData = new FormData();
            formData.append("name", this.company.name);
            formData.append("email", this.company.email);
            formData.append("phone", this.company.phone);
            if (this.company.logo) {
                formData.append("image", this.company.logo);
            }

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
    --box-shadow: 0 2rem 3rem var(--clr-light);
}

.containers {
    padding: var(--padding-1);
    background: var(--clr-color-background);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
}

.header {
    width: 100%;
    text-align: center;
    margin-bottom: var(--padding-1);
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
    background: var(--clr-white);
    padding: var(--padding-1);
    border-radius: var(--border-radius-2);
    box-shadow: var(--box-shadow);
    width: 100%;
}

.profile-form {
    display: flex;
    flex-direction: column;
    gap: var(--padding-1);
    width: 100%;
}

.form-group {
    display: flex;
    flex-direction: column;
}

label {
    margin-bottom: 5px;
    font-weight: 500;
    color: var(--clr-dark);
}

input,
select,
textarea {
    padding: var(--padding-1);
    border: 1px solid var(--clr-info-light);
    border-radius: var(--border-radius-1);
    transition: border-color 0.3s;
    width: 100%;
    font-size: 1rem;
}

input:focus,
select:focus,
textarea:focus {
    border-color: var(--clr-primary);
}

.submit-btn {
    text-align: center;
}

.submit-btn button {
    padding: var(--padding-1) 20px;
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border: none;
    border-radius: var(--border-radius-1);
    cursor: pointer;
    transition: background-color 0.3s;
    margin-right: 10px;
}

.submit-btn button:hover {
    background-color: var(--clr-primary-variant);
}

.image-upload {
    display: flex;
    align-items: center;
}

.image-upload-container {
    display: flex;
    align-items: center;
    gap: 10px;
}

.image-upload-container input[type="file"] {
    flex-shrink: 0;
}

.image-upload-container img {
    width: 70px;
    height: 70px;
    object-fit: cover;
    border: 2px solid var(--clr-info-light);
    border-radius: 50%;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s ease-in-out;
}

.image-upload-container img:hover {
    transform: scale(1.05);
}

/* Media Queries for Responsive Design */
@media screen and (max-width: 768px) {
    .containers {
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
