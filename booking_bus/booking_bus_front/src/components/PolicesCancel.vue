<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <header class="navd">
            <button class="nav-btnd" @click="showCancelForm = true">
                Cancel Trip
            </button>
            <button class="nav-btnd" @click="showCancelForm = false">
                ______
            </button>
            <button class="nav-btnd" @click="showDriverStatusModal = true">
                ______
            </button>
            <button class="nav-btnd" @click="fetchAllDriverWithBus">
                ______
            </button>
        </header>

        <!-- Cancel Trip Form -->
        <div class="containers" v-if="showCancelForm">
            <div class="content">
                <div class="form-container">
                    <form class="profile-form" @submit.prevent="submitForm">
                        <div class="form-group">
                            <label for="searchable-select"
                                >Searchable Select</label
                            >
                            <div class="searchable-select-wrapper">
                                <input
                                    type="text"
                                    v-model="searchQuery"
                                    @input="filterOptions"
                                    placeholder="Search..."
                                    class="search-input"
                                />
                                <select
                                    id="searchable-select"
                                    v-if="filteredOptions.length > 0"
                                >
                                    <option value="" disabled selected>
                                        Select an option
                                    </option>
                                    <option
                                        v-for="(
                                            option, index
                                        ) in limitedOptions"
                                        :key="index"
                                        :value="option.value"
                                    >
                                        {{ option.text }}
                                    </option>
                                </select>
                                <p v-else>No matching options</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea
                                id="description"
                                v-model="formData.description"
                                placeholder="Enter your description here"
                                class="description-input"
                            ></textarea>
                        </div>
                        <!-- Field Group with Buttons -->
                        <div
                            v-for="(field, index) in formData.fields"
                            :key="index"
                            class="field-group"
                        >
                            <div class="field-group">
                                <div class="form-group">
                                    <label :for="'field-' + index"
                                        >Problem</label
                                    >
                                    <div class="input-with-buttons">
                                        <input
                                            type="text"
                                            :id="'field-' + index"
                                            v-model="field.value"
                                            placeholder="Enter Problem"
                                        />
                                        <button
                                            class="delete-btn"
                                            @click="removeField(index)"
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                        <button
                                            class="add-btn"
                                            @click="addField"
                                        >
                                            <span class="material-icons"
                                                >add</span
                                            >
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="nav-btnd">
                                Save Cancel
                            </button>
                            <button
                                type="button"
                                class="nav-btnd"
                                @click="showCompensationModal = true"
                            >
                                Financial compensation
                            </button>
                        </div>

                        <div class="modal" v-if="showCompensationModal">
                            <div class="modal-content">
                                <button
                                    class="close-btn"
                                    @click="showCompensationModal = false"
                                >
                                    &times;
                                </button>
                                <h3>Financial compensation</h3>

                                <div class="form-group">
                                    <label for="compensation-percentage"
                                        >Satisfaction Rate</label
                                    >
                                    <input
                                        type="text"
                                        id="compensation-percentage"
                                        v-model="compensationData.percentage"
                                        placeholder="Enter the compensation percentage"
                                    />
                                </div>

                                <div class="form-group">
                                    <label for="compensation-description"
                                        >description</label
                                    >
                                    <textarea
                                        id="compensation-description"
                                        v-model="compensationData.description"
                                        placeholder="Enter compensation description"
                                    ></textarea>
                                </div>

                                <div class="modal-actions">
                                    <button
                                        @click="saveCompensation"
                                        class="nav-btnd"
                                    >
                                        Save
                                    </button>
                                    <button
                                        @click="showCompensationModal = false"
                                        class="nav-btnd"
                                    >
                                        Cancel
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    name: "YourComponent",
    data() {
        return {
            searchQuery: "",
            options: [], // For select options
            filteredOptions: [],
            trips: [], // For detailed trip data
            formData: {
                description: "",
                fields: [{ value: "" }],
            },
            showCompensationModal: false,
            compensationData: {
                percentage: "",
                description: "",
            },
            showCancelForm: true,
            isDarkMode: false,
        };
    },
    computed: {
        limitedOptions() {
            return this.filteredOptions.slice(0, 6);
        },
    },
    methods: {
        fetchTripsData() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/all_trips", {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                })
                .then((response) => {
                    this.trips = response.data.map((trip) => ({
                        name: `${trip.path.from} to ${trip.path.to}`,
                        from: trip.path.from,
                        to: trip.path.to,
                        price: parseFloat(trip.price),
                        status: trip.status,
                    }));

                    this.options = response.data.map((trip) => ({
                        value: trip.id,
                        text: `${trip.path.from} to ${trip.path.to}`,
                    }));
                    this.filteredOptions = this.options; // Initialize filtered options
                })
                .catch((error) => {
                    console.error("Error fetching trips data:", error);
                });
        },
        filterOptions() {
            const query = this.searchQuery.toLowerCase();
            this.filteredOptions = this.options.filter((option) =>
                option.text.toLowerCase().includes(query)
            );
        },
        submitForm() {
            // Handle form submission
            console.log("Form submitted:", this.formData);
        },
        saveCompensation() {
            // معالجة البيانات وحفظها هنا
            console.log(this.compensationData);
            this.showCompensationModal = false;
        },
        handleLogoUpload(event) {
            // Handle logo upload
            const file = event.target.files[0];
            console.log("Logo uploaded:", file);
        },
        addField() {
            this.formData.fields.push({ value: "" });
        },
        removeField(index) {
            if (this.formData.fields.length > 1) {
                this.formData.fields.splice(index, 1);
            }
        },
        updateProfile() {
            // Handle profile update
            console.log("Profile updated:", this.formData);
        },
        fetchAllDriverWithBus() {
            // Fetch drivers with bus logic
            console.log("Fetching drivers with bus...");
        },
    },
    mounted() {
        this.fetchTripsData(); // Fetch data when component is mounted
    },
};
</script>

<style scoped>
/* Global Styles */
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap");

/* Root Variables */
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
    --clr-danger-variant: #e93947;
    --clr-dark-variant: #677483;
    --clr-color-background: #f6f6f9;
    --card-border-radius: 2rem;
    --border-radius-1: 0.4rem;
    --border-radius-2: 0.8rem;
    --border-radius-3: 1.2rem;
    --card-padding: 1.8rem;
    --padding-1: 1.2rem;
    --box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}

/* Dark Theme Variables */
.dark-theme-variables {
    --clr-primary: #bb86fc;
    --clr-danger: #cf6679;
    --clr-success: #03dac6;
    --clr-white: #121212;
    --clr-info-dark: #bb86fc;
    --clr-info-light: #292929;
    --clr-dark: #f6f6f9;
    --clr-warning: #ffbb55;
    --clr-light: rgba(255, 255, 255, 0.2);
    --clr-primary-variant: #3700b3;
    --clr-dark-variant: #1f1f1f;
    --clr-color-background: #121212;
}

/* Reset Styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
    border: 0;
    list-style: none;
    appearance: none;
}

body {
    font-family: "Poppins", sans-serif;
    width: 100%;
    height: 100%;
    font-size: 0.88rem;
    user-select: none;
    background: var(--clr-color-background);
}

/* Container Styles */
.containers {
    padding: 20px;
    background: var(--clr-color-background);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    min-height: 100vh;
}

/* Header Styles */
.header {
    width: 100%;
    text-align: center;
    margin-bottom: 20px;
    color: var(--clr-dark);
}

/* Content Styles */
.content {
    width: 100%;
    max-width: 800px;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 0 auto;
}

/* Form Styles */
.form-container {
    background: var(--clr-white);
    padding: var(--padding-1);
    border-radius: var(--border-radius-3);
    box-shadow: var(--box-shadow);
    width: 100%;
}

.profile-form {
    display: flex;
    flex-direction: column;
    gap: 15px;
    width: 100%;
}

.fields-container {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Field Group Styles */

.form-group {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 5px;
    margin: 0;
}

.input-with-buttons {
    display: flex;
    align-items: center;
    gap: 10px;
}

.input-with-buttons input {
    flex: 1;
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    font-size: 1rem;
}

.input-with-buttons button {
    height: 40px;
    width: 40px;
    padding: 5px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: var(--border-radius-1);
    background-color: var(--clr-primary);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s, transform 0.3s;
}

.input-with-buttons button.delete-btn {
    background-color: var(--clr-danger);
}

.input-with-buttons button.add-btn {
    background-color: var(--clr-primary);
}

.input-with-buttons button:hover {
    transform: scale(1.05);
}

.input-with-buttons button.delete-btn:hover {
    color: var(--clr-danger-variant);
}

.input-with-buttons button.add-btn:hover {
    color: var(--clr-primary-variant);
}

/* Ensure button spacing is correct */
.field-group input {
    flex: 1;
}

/* Specific adjustments for the form */

.field-group .form-group {
    flex: 1;
    margin: 0;
}

.field-group button {
    margin: 0 5px;
}

/* Adjusting input width and spacing */
.field-group input {
    flex: 1;
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    font-size: 1rem;
}

.field-group .form-group {
    margin: 0;
}

/* Add some space around the buttons */
/* Smaller Button Styles */
.add-field-btn,
.remove-field-btn {
    padding: 2px;
    border: none;
    border-radius: var(--border-radius-1);
    background-color: var(--clr-primary);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 0.75rem;
    height: 25px;
    width: 25px;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Button Hover States */
.add-field-btn:hover {
    background-color: var(--clr-primary-variant);
}

.remove-field-btn {
    background-color: var(--clr-danger);
}

.remove-field-btn:hover {
    background-color: var(--clr-danger-variant);
}

/* Smaller Icon Styles */
.material-icons {
    font-size: 20px;
    line-height: 1;
}

/* Adjust button placement and spacing */
.field-group button {
    margin-left: 10px;
}

.searchable-select-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.search-input {
    margin-bottom: 5px;
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    font-size: 1rem;
}

#searchable-select {
    width: 100%;
    max-width: 400px;
    padding: 10px;
    border: 1px solid var(--clr-primary);
    border-radius: var(--border-radius-1);
    font-size: 1rem;
    margin-top: 5px;
    background-color: var(--clr-light);
    color: var(--clr-dark);
    text-align: center;
}

#searchable-select option {
    color: var(--clr-dark);
}

.description-input {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    min-height: 100px;
    resize: vertical;
    font-family: Arial, sans-serif;
    font-size: 1rem;
    background-color: var(--clr-white);
}

label {
    margin-bottom: 8px;
    font-weight: 500;
    color: var(--clr-dark);
    display: block;
}

input,
select,
textarea {
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
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
    padding: 10px 20px;
    border: none;
    border-radius: 25px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
}

@keyframes gradientAnimation {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.submit-btn button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s;
}
/* Styles for the modal (popup) */
.modal {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
}

.modal-content {
    background: var(--clr-white);
    padding: 20px;
    border-radius: 10px;
    max-width: 500px;
    width: 80%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    position: relative;
}

/* Close button styles */
.close-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    background: none;
    border: none;
    font-size: 24px;
    font-weight: bold;
    cursor: pointer;
    color: var(--clr-dark);
}

.close-btn:hover {
    color: var(--clr-danger);
}

.modal h3 {
    text-align: center;
    color: var(--clr-dark-variant);
    font-size: 1.5rem;
    margin-bottom: 15px;
}

.modal-actions {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.modal-actions button {
    padding: 10px 20px;
    border-radius: 25px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
}

.modal-actions button:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
}
.form-group label {
    font-size: 1.1rem;
    color: var(--clr-dark-variant);
    font-weight: bold;
    margin-top: 10px;
}
input::placeholder,
textarea::placeholder {
    font-family: "Poppins", sans-serif;
    font-size: 1rem;
    color: var(--clr-info-dark);
    opacity: 1;
}

/* Input and Textarea styles to ensure consistency */
input,
textarea {
    font-family: "Poppins", sans-serif;
    font-size: 1rem;
}

/* Navigation Styles */
.navd {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    margin-top: 20px;
    background-color: var(--clr-white);
    border-radius: var(--border-radius-3);
    width: 100%;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: 25px;
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
}
.button-group {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-top: 15px;
}

@keyframes gradientAnimation {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.nav-btnd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s;
}

@media (max-width: 768px) {
    .nav-btnd {
        margin: 5px;
    }
}

@media (max-width: 576px) {
    .content {
        padding: 10px;
    }

    .nav-btnd {
        padding: 8px 16px;
        font-size: 10px;
    }

    .form-container {
        padding: 15px;
    }

    .profile-form {
        gap: 10px;
    }
}
</style>
