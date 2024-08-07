<template>
    <div class="containers">
        <div class="content">
            <div class="form-container">
                <form class="profile-form">
                    <div class="form-group">
                        <label>Company Name</label>
                        <input
                            type="text"
                            id="companyName"
                            placeholder="Enter Company Name"
                            v-model="company.name"
                        />
                    </div>
                    <div class="form-group">
                        <label for="industry">Industry</label>
                        <input
                            type="text"
                            id="industry"
                            placeholder="Enter Industry"
                            v-model="company.industry"
                        />
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea
                            id="address"
                            placeholder="Enter Company Address"
                            v-model="company.address"
                            rows="3"
                        ></textarea>
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
                        <label for="email">Email</label>
                        <input
                            type="email"
                            id="email"
                            placeholder="Enter Email"
                            v-model="company.email"
                        />
                    </div>
                    <div class="form-group">
                        <label for="website">Website</label>
                        <input
                            type="url"
                            id="website"
                            placeholder="Enter Website URL"
                            v-model="company.website"
                        />
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea
                            id="description"
                            placeholder="Enter Company Description"
                            v-model="company.description"
                            rows="5"
                        ></textarea>
                    </div>
                    <div class="form-group">
                        <label for="password">New Password</label>
                        <input
                            type="password"
                            id="password"
                            placeholder="Enter New Password"
                            v-model="company.password"
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
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "ProfileCompanys",
    data() {
        return {
            company: {
                name: "",
                industry: "",
                address: "",
                phone: "",
                email: "",
                website: "",
                description: "",
                password: "",
                logo: null,
            },
        };
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
