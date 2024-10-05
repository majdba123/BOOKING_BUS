<template>
    <div :class="['containerd', { 'dark-theme-variables': isDarkMode }]">
        <header class="navd">
            <button class="nav-btnd" @click="showCancelTripPage">
                Cancel Trip
            </button>
            <button class="nav-btnd" @click="showAllRewardsPage">
                All Rewards
            </button>
            <button class="nav-btnd" @click="showDriverStatusModal">
                Rule
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
                                    v-model="formData.trip_id"
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
                            v-for="(field, index) in formData.reasons"
                            :key="index"
                            class="field-group"
                        >
                            <div class="form-group">
                                <label :for="'field-' + index">Problem</label>
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
                                    <button class="add-btn" @click="addField">
                                        <span class="material-icons">add</span>
                                    </button>
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
                                    <label for="compensation-percentage">
                                        Satisfaction Rate
                                    </label>
                                    <input
                                        type="text"
                                        id="compensation-percentage"
                                        v-model="compensationData.rate"
                                        placeholder="Enter the compensation percentage"
                                    />
                                </div>

                                <div class="form-group">
                                    <label for="compensation-description">
                                        Description
                                    </label>
                                    <textarea
                                        class="description-input"
                                        id="compensation-description"
                                        v-model="
                                            compensationData.satisfaction_rate_description
                                        "
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

        <!-- All Rewards Page -->
        <div v-if="showAllRewards" class="recent_orders">
            <h2>All Rewards</h2>

            <!-- Form for adding or editing rewards -->
            <div class="form-container">
                <form
                    @submit.prevent="
                        editingIndex !== null
                            ? saveEditedChanges()
                            : saveChanges()
                    "
                >
                    <div class="form-group">
                        <label for="reward-percentage"
                            >Reward Percentage:</label
                        >
                        <input
                            type="text"
                            v-model="reward_percentage"
                            id="reward-percentage"
                            required
                            placeholder="Enter reward-percentage"
                        />
                    </div>
                    <div class="form-group">
                        <label for="reservation-cost">Reservation Cost:</label>
                        <input
                            type="text"
                            v-model="price"
                            id="reservation-cost"
                            required
                            placeholder="Enter reservation-cost"
                        />
                    </div>
                    <button type="submit" class="save-btn">
                        <span class="material-icons"> add </span>
                    </button>
                </form>
            </div>

            <!-- Table displaying all rewards -->
            <div class="table-container">
                <div v-if="loading" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div v-if="!Rewards.length > 0" class="no-data-message">
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Reward ID</th>
                                    <th>Percentage</th>
                                    <th>Reservation Cost</th>
                                    <th>Delete</th>
                                    <th>Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(reward, index) in Rewards"
                                    :key="index"
                                >
                                    <td>{{ index }}</td>
                                    <td>{{ reward.reward_percentage }}%</td>
                                    <td>{{ reward.Reservation_Costs }}</td>

                                    <td>
                                        <button
                                            class="delete-btn"
                                            @click="
                                                confirmDeleteReward(reward.id)
                                            "
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="edit-btn"
                                            @click="
                                                editReward(index, reward.id)
                                            "
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Confirm Delete Reward Modal -->
            <div v-if="showDeleteConfirmModal" class="dialog-container">
                <div class="dialog-box">
                    <div class="dialog-header">Confirm Delete</div>
                    <div class="dialog-body">
                        Are you sure about the deletion process?
                    </div>
                    <div class="dialog-footer">
                        <button @click="deleteReward" class="confirm-btn">
                            Yes
                        </button>
                        <button
                            @click="closeDeleteConfirmModal"
                            class="cancels-btn"
                        >
                            No
                        </button>
                    </div>
                </div>
            </div>

            <!-- Modal for adding or editing rewards -->
            <div v-if="showModal" class="modal-overlay" @click="closeModal">
                <div class="modal-content" @click.stop>
                    <h2>
                        {{
                            editingIndex !== null
                                ? "Edit Reward"
                                : "Add New Reward"
                        }}
                    </h2>
                    <form
                        @submit.prevent="
                            editingIndex !== null
                                ? saveEditedChanges()
                                : saveChanges()
                        "
                    >
                        <div class="form-group">
                            <label for="reward-percentage"
                                >Reward Percentage:</label
                            >
                            <input
                                type="text"
                                v-model="reward_percentage"
                                id="reward-percentage"
                                required
                            />
                        </div>
                        <div class="form-group">
                            <label for="reservation-cost"
                                >Reservation Cost:</label
                            >
                            <input
                                type="text"
                                v-model="price"
                                id="reservation-cost"
                                required
                            />
                        </div>
                        <div class="modal-actions">
                            <button type="submit" class="save-btn">
                                <span class="material-icons">
                                    {{ editingIndex !== null ? "save" : "add" }}
                                </span>
                                {{ editingIndex !== null ? "" : "Add Reward" }}
                            </button>
                            <button
                                type="button"
                                class="cancel-btn"
                                @click="closeModal"
                            >
                                <span class="material-icons">cancel</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- All rules -->
        <div v-if="showAllRules" class="recent_orders">
            <h2>All Cancellation Rules</h2>

            <div class="form-container">
                <form @submit.prevent="addRule()">
                    <div class="form-group">
                        <label for="hours-before">Hours Before:</label>
                        <input
                            type="number"
                            v-model="ruleHoursBefore"
                            id="hours-before"
                            required
                            placeholder="Enter hours before"
                        />
                    </div>
                    <div class="form-group">
                        <label for="discount-percentage"
                            >Discount Percentage:</label
                        >
                        <input
                            type="number"
                            v-model="ruleDiscountPercentage"
                            id="discount-percentage"
                            required
                            placeholder="Enter discount percentage"
                        />
                    </div>
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea
                            v-model="ruleDescription"
                            id="description"
                            required
                            placeholder="Enter description"
                            class="description-input"
                        ></textarea>
                    </div>
                    <button type="submit" class="save-btn">
                        <span class="material-icons"> add </span>
                    </button>
                </form>
            </div>

            <!-- Table displaying all rules -->
            <div class="table-container">
                <div v-if="loading1" class="spinner-container">
                    <div class="spinner"></div>
                </div>
                <div v-else>
                    <div
                        v-if="!cancellationRules.length"
                        class="no-data-message"
                    >
                        No Data Available
                    </div>
                    <div v-else>
                        <table>
                            <thead>
                                <tr>
                                    <th>Hours Before</th>
                                    <th>Discount Percentage</th>
                                    <th>Description</th>
                                    <th>Delete</th>
                                    <th>Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr
                                    v-for="(rule, index) in cancellationRules"
                                    :key="rule.id"
                                >
                                    <td>{{ rule.hours_before }}</td>
                                    <td>{{ rule.discount_percentage }}%</td>
                                    <td>{{ rule.description }}</td>
                                    <td>
                                        <button
                                            class="delete-btn"
                                            @click="
                                                openDeleteConfirmModal(rule)
                                            "
                                        >
                                            <span class="material-icons"
                                                >delete</span
                                            >
                                        </button>
                                    </td>
                                    <td>
                                        <button
                                            class="edit-btn"
                                            @click="editRule(index, rule.id)"
                                        >
                                            <span class="material-icons"
                                                >edit</span
                                            >
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Confirm Delete Rule Modal -->
            <div v-if="showDeleteConfirmModal" class="dialog-container">
                <div class="dialog-box">
                    <div class="dialog-header">Confirm Delete</div>
                    <div class="dialog-body">
                        Are you sure you want to delete this cancellation rule?
                    </div>
                    <div class="dialog-footer">
                        <button
                            @click="deleteConfirmedRule"
                            class="confirm-btn"
                        >
                            Yes
                        </button>
                        <button
                            @click="closeDeleteConfirmModal"
                            class="cancels-btn"
                        >
                            No
                        </button>
                    </div>
                </div>
            </div>

            <!-- Modal for adding or editing rules -->
            <div v-if="showModal" class="modal-overlay" @click="closeRuleModal">
                <div class="modal-content" @click.stop>
                    <h2>
                        {{
                            selectedRuleId !== null
                                ? "Edit Cancellation Rule"
                                : "Add New Cancellation Rule"
                        }}
                    </h2>
                    <form
                        @submit.prevent="
                            selectedRuleId !== null ? updateRule() : addRule()
                        "
                    >
                        <div class="form-group">
                            <label for="hours-before">Hours Before:</label>
                            <input
                                type="number"
                                v-model="ruleHoursBefore"
                                id="hours-before"
                                required
                            />
                        </div>
                        <div class="form-group">
                            <label for="discount-percentage"
                                >Discount Percentage:</label
                            >
                            <input
                                type="number"
                                v-model="ruleDiscountPercentage"
                                id="discount-percentage"
                                required
                            />
                        </div>
                        <div class="form-group">
                            <label for="description">Description:</label>
                            <textarea
                                v-model="ruleDescription"
                                id="description"
                                required
                                class="description-input"
                            ></textarea>
                        </div>
                        <div class="modal-actions">
                            <button type="submit" class="save-btn">
                                <span class="material-icons">
                                    {{
                                        selectedRuleId !== null ? "save" : "add"
                                    }}
                                </span>
                                {{ selectedRuleId !== null ? "" : "Add Rule" }}
                            </button>
                            <button
                                type="button"
                                class="cancel-btn"
                                @click="closeRuleModal"
                            >
                                <span class="material-icons">cancel</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
    name: "PolicesCancel",
    data() {
        return {
            loading: true,
            loading1: true,

            searchQuery: "",
            options: [],
            filteredOptions: [],
            trips: [],
            Rewards: [],
            editingIndex: null,
            price: "",
            reward_percentage: "",
            x: null,
            formData: {
                id: "",
                description: "",
                reasons: [{ value: "" }],
            },
            showCompensationModal: false,
            compensationData: {
                rate: "0",
                satisfaction_rate_description: "null",
            },
            showCancelForm: true,
            showAllRewards: false,
            isDarkMode: false,
            showModal: false,
            isEditing: false,
            showAllRules: false,
            cancellationRules: [],
            selectedRuleId: null,
            toast: useToast(),
            showDeleteConfirmModal: false,
            ruleToDelete: null,
            rewardToDelete: null,
        };
    },
    methods: {
        showCancelTripPage() {
            this.showCancelForm = true;
            this.showAllRewards = false;
            this.showAllRules = false;
        },
        showAllRewardsPage() {
            this.showCancelForm = false;
            this.showAllRewards = true;
            this.showAllRules = false;
            this.AllRewards();
        },
        showDriverStatusModal() {
            this.showCancelForm = false;
            this.showAllRewards = false;
            this.showAllRules = true;
        },
        closeRuleModal() {
            this.showModal = false;
            this.ruleHoursBefore = "";
            this.ruleDiscountPercentage = "";
            this.ruleDescription = "";
            this.selectedRuleId = null;
        },
        AllRewards() {
            const access_token = window.localStorage.getItem("access_token");
            axios({
                method: "get",
                url: "http://127.0.0.1:8000/api/company/rewards/",
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Rewards = response.data;
                    this.loading = false;
                })
                .catch(() => {
                    this.toast.error("Error Getting Rewards");
                });
            this.loading = true;
        },

        editReward(index, id) {
            this.editingIndex = index;
            this.x = id;
            const reward = this.Rewards[index];
            this.reward_percentage = reward.reward_percentage;
            this.price = reward.Reservation_Costs;
            this.isEditing = true;
            this.showModal = true;
        },

        openAddModal() {
            this.editingIndex = null;
            this.reward_percentage = "";
            this.price = "";
            this.isEditing = false;
            this.showModal = true;
        },

        closeModal() {
            this.showModal = false;
            this.resetForm();
        },

        resetForm() {
            this.reward_percentage = "";
            this.price = "";
            this.x = null;
            this.editingIndex = null;
        },

        saveEditedChanges() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "put",
                url: `http://127.0.0.1:8000/api/company/rewards/${this.x}`,
                headers: { Authorization: `Bearer ${token}` },
                data: {
                    Reservation_Costs: this.price,
                    reward_percentage: this.reward_percentage,
                },
            })
                .then((response) => {
                    this.Rewards[this.editingIndex] = response.data;
                    this.closeModal();
                    this.AllRewards();
                    this.toast.success("Reward Updated Successfully");
                })
                .catch(() => {
                    this.toast.error("Error Updating Reward");
                });
        },

        saveChanges() {
            const token = window.localStorage.getItem("access_token");

            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/company/rewards/store",
                headers: { Authorization: `Bearer ${token}` },
                data: {
                    Reservation_Costs: this.price,
                    reward_percentage: this.reward_percentage,
                },
            })
                .then((response) => {
                    this.Rewards.push(response.data);
                    this.closeModal();
                    this.toast.success("Reward Added Successfully");
                    this.AllRewards();
                })
                .catch(() => {
                    this.toast.error("Error Adding Reward");
                });
        },

        confirmDeleteReward(id) {
            this.rewardToDelete = id;
            this.showDeleteConfirmModal = true;
        },

        deleteReward() {
            if (this.rewardToDelete) {
                const access_token =
                    window.localStorage.getItem("access_token");
                axios({
                    method: "delete",
                    url: `http://127.0.0.1:8000/api/company/rewards/${this.rewardToDelete}`,
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                    .then(() => {
                        this.Rewards = this.Rewards.filter(
                            (rewardItem) =>
                                rewardItem.id !== this.rewardToDelete
                        );
                        this.toast.success("Reward Deleted Successfully");
                        this.AllRewards();
                    })
                    .catch(() => {
                        this.toast.error("Error Deleting Reward");
                    });
                this.showDeleteConfirmModal = false;
                this.rewardToDelete = null;
            } else {
                // console.error("No reward selected for deletion.");
            }
        },
        fetchTripsData() {
            // console.log("Fetching trips data...");
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/all_trips", {
                    headers: { Authorization: `Bearer ${accessToken}` },
                })
                .then((response) => {
                    // console.log("Trips data fetched:", response.data);
                    this.trips = response.data.map((trip) => ({
                        name: `${trip.path.from} to ${trip.path.to}`,
                        from: trip.path.from,
                        to: trip.path.to,
                    }));

                    this.options = response.data.map((trip) => ({
                        value: trip.id,
                        text: `${trip.path.from} to ${trip.path.to}`,
                    }));
                    this.filteredOptions = this.options;
                })
                .catch(() => {
                    this.toast.error("Error fetching trips data");
                });
        },

        filterOptions() {
            const query = this.searchQuery.toLowerCase();
            this.filteredOptions = this.options.filter((option) =>
                option.text.toLowerCase().includes(query)
            );
        },

        submitForm() {
            const accessToken = window.localStorage.getItem("access_token");
            if (!this.formData.trip_id || !this.formData.description) {
                this.toast.error("Please fill in all required fields.");
                return;
            }

            const payload = {
                trip_id: this.formData.trip_id,
                description: this.formData.description,
                reasons: this.formData.reasons.map((field) => field.value),
                rate: this.compensationData.rate,
                satisfaction_rate_description:
                    this.compensationData.satisfaction_rate_description,
            };
            // console.log("Selected trip ID:", this.formData.trip_id);
            if (
                !this.options.some(
                    (option) => option.value === this.formData.trip_id
                )
            ) {
                this.toast.error("Selected trip is invalid.");
                return;
            }

            axios
                .post(
                    "http://127.0.0.1:8000/api/company/trips/cancel",
                    payload,
                    {
                        headers: { Authorization: `Bearer ${accessToken}` },
                    }
                )
                .then(() => {
                    this.toast.success("Trip cancellation successful!");
                })
                .catch((error) => {
                    const errorMessage = error.response
                        ? `Error cancelling trip: ${
                              error.response.data.message || error.response.data
                          }`
                        : `Error cancelling trip: ${error.message}`;
                    this.toast.error(errorMessage);
                });
        },

        saveCompensation() {
            this.showCompensationModal = false;
        },

        addField() {
            this.formData.reasons.push({ value: "" });
        },

        removeField(index) {
            if (this.formData.reasons.length > 1) {
                this.formData.reasons.splice(index, 1);
            }
        },

        loadCancellationRules() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/cancellation-rules/", {
                    headers: { Authorization: `Bearer ${accessToken}` },
                })
                .then((response) => {
                    this.cancellationRules = response.data;
                    this.loading1 = false;
                })
                .catch(() => {
                    this.toast.error("Error fetching cancellation rules");
                });
            this.loading1 = true;
        },
        addRule() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .post(
                    "http://127.0.0.1:8000/api/company/cancellation-rules/store",
                    {
                        hours_before: this.ruleHoursBefore,
                        discount_percentage: this.ruleDiscountPercentage,
                        description: this.ruleDescription,
                    },
                    {
                        headers: { Authorization: `Bearer ${accessToken}` },
                    }
                )
                .then(() => {
                    this.loadCancellationRules();
                    this.toast.success("Cancellation Rule Added Successfully");
                })
                .catch(() => {
                    this.toast.error("Error adding cancellation rule");
                });
        },
        updateRule() {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .put(
                    `http://127.0.0.1:8000/api/company/cancellation-rules/${this.selectedRuleId}`,
                    {
                        hours_before: this.ruleHoursBefore,
                        discount_percentage: this.ruleDiscountPercentage,
                        description: this.ruleDescription,
                    },
                    {
                        headers: { Authorization: `Bearer ${accessToken}` },
                    }
                )
                .then(() => {
                    this.loadCancellationRules();
                    this.closeRuleModal();
                    this.toast.success(
                        "Cancellation Rule Updated Successfully"
                    );
                })
                .catch(() => {
                    this.toast.error("Error updating cancellation rule");
                });
        },
        openDeleteConfirmModal(rule) {
            this.ruleToDelete = rule;
            this.showDeleteConfirmModal = true;
        },
        closeDeleteConfirmModal() {
            this.showDeleteConfirmModal = false;
            this.ruleToDelete = null;
        },
        deleteConfirmedRule() {
            if (this.ruleToDelete && this.ruleToDelete.id) {
                this.deleteRule(this.ruleToDelete.id);
            } else {
                // console.error("No cancellation rule selected for deletion.");
            }
            this.closeDeleteConfirmModal();
        },
        deleteRule(id) {
            const accessToken = window.localStorage.getItem("access_token");
            axios
                .delete(
                    `http://127.0.0.1:8000/api/company/cancellation-rules/${id}`,
                    {
                        headers: { Authorization: `Bearer ${accessToken}` },
                    }
                )
                .then(() => {
                    this.loadCancellationRules();
                    this.toast.success(
                        "Cancellation Rule Deleted Successfully"
                    );
                })
                .catch(() => {
                    this.toast.error("Error deleting cancellation rule");
                });
        },

        editRule(index, id) {
            this.editingIndex = index;
            this.selectedRuleId = id;
            const rule = this.cancellationRules[index];
            this.ruleHoursBefore = rule.hours_before;
            this.ruleDiscountPercentage = rule.discount_percentage;
            this.ruleDescription = rule.description;
            this.showModal = true;
        },

        openAddRuleModal() {
            this.editingIndex = null;
            this.selectedRuleId = null;
            this.ruleHoursBefore = "";
            this.ruleDiscountPercentage = "";
            this.ruleDescription = "";
            this.showModal = true;
        },
    },
    mounted() {
        this.fetchTripsData();
        this.loadCancellationRules();
    },
    computed: {
        limitedOptions() {
            return this.filteredOptions.slice(0, 10);
        },
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
h2 {
    font-size: 1.2rem;
    color: var(--clr-dark);
    margin-bottom: 5px;
    margin-left: 15px;
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

.spinner {
    border: 4px solid var(--clr-light);
    border-left-color: var(--clr-primary);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

.spinner-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 30vh;
}

/* Add this part for the spinner rotation */
@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}
.no-data-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    font-size: 1.2rem;
    color: #677483;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: var(--border-radius-2);
    background-color: #f6f6f9;
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
    width: 100%;
}

/* Header Styles */
.header {
    width: 100%;
    text-align: center;
    margin-bottom: 20px;
    color: var(--clr-dark);
}
/* Modal Styling delete*/
.dialog-container {
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

.dialog-box {
    background-color: var(--clr-white);
    color: var(--clr-dark);
    padding: 15px;
    border-radius: 10px;
    max-width: 400px;
    width: 50%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    text-align: center;
}

.dialog-header,
.dialog-body,
.dialog-footer {
    margin-bottom: 15px;
}

.dialog-header {
    font-size: 1.3rem;
    font-weight: bold;
    text-align: center;
}

.dialog-body {
    text-align: center;
}

.dialog-footer {
    display: flex;
    justify-content: center;
    gap: 10px;
}

.confirm-btn {
    padding: 8px 16px;
    background-color: #5cb85c;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.confirm-btn:hover {
    background-color: #4cae4c;
}

.cancels-btn {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.cancels-btn:hover {
    background-color: #c9302c;
}

.close-modal {
    padding: 8px 16px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

/* Modal background overlay */
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

/* Modal content box */
.modal-content {
    background: #fff;
    padding: 20px;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
    animation: fadeIn 0.3s ease-in-out;
}

/* Modal header style */
.modal-header {
    font-size: 1.2rem;
    font-weight: bold;
    margin-bottom: 10px;
    text-align: center;
}

/* Modal body style */
.modal-body {
    margin-bottom: 20px;
    text-align: center;
    font-size: 1rem;
}

/* Modal footer style */
.modal-footer {
    display: flex;
    justify-content: center;
    gap: 10px;
}

/* Button styles */
.update-btn,
.close-modal {
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

/* Style for 'Yes' button */
.update-btn {
    background-color: #28a745; /* Green background */
    color: white;
}

.update-btn:hover {
    background-color: #218838; /* Darker green */
}

/* Style for 'No' button */
.close-modal {
    background-color: #dc3545; /* Red background */
    color: white;
}

.close-modal:hover {
    background-color: #c82333; /* Darker red */
}

/* Content Styles */
.content {
    width: 100%;
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
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
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
    margin-bottom: 15px;
    width: 100%;
}
form {
    width: 100%;
}

.save-btn {
    display: block;
    padding: 10px 20px;
    font-size: 16px;
    text-align: center;
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
    align-items: center;
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
    background-color: var(--clr-white);
    border-radius: 10px;
    width: 100%;
}

.nav-btnd {
    padding: 10px 20px;
    margin: 10px;
    border: none;
    border-radius: var(--border-radius-2);
    background: linear-gradient(90deg, var(--clr-primary) 0%, #007bff 100%);
    color: var(--clr-white);
    cursor: pointer;
    font-size: 15px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
    width: 100%;
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
    transition: 0.3s ease;
}
.button-group {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-top: 15px;
}

/* General Table Styles */
.recent_orders {
    width: 100%;
    overflow-x: auto;
    margin-top: 20px;
}

.table-container {
    width: 100%;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}

.recent_orders table {
    background-color: var(--clr-white);
    width: 100%;
    border-radius: var(--border-radius-1);
    padding: var(--padding-1);
    text-align: center;
    box-shadow: var(--box-shadow);
    color: var(--clr-dark);
    max-width: none;
    font-size: 0.85rem;
}

.recent_orders table:hover {
    box-shadow: none;
}

table thead tr th {
    padding: 10px;
    font-size: 0.9rem;
    color: var(--clr-dark);
}

table tbody tr {
    height: 3rem;
    border-bottom: 1px solid var(--clr-white);
    color: var(--clr-dark-variant);
}

table tbody td {
    height: 3rem;
    border-bottom: 1px solid var(--clr-dark);
    color: var(--clr-dark-variant);
}

table tbody tr:last-child td {
    border: none;
}

.edit-btn.material-icons,
.delete-btn.material-icons,
.details-btn.material-icons {
    padding: 2px 6px;
    border: none;
    margin: 8px;
    border-radius: 9px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 20px;
    width: 25px;
}

.edit-btn {
    color: #4caf50;
    background-color: var(--clr-white);
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}

.edit-btn:hover {
    color: var(--clr-white);
    background-color: var(--clr-success);
}

.delete-btn {
    color: #f44336;
    background-color: var(--clr-white);
    border-radius: 9px;
    padding: 3px;
    margin: 5px;
}

.delete-btn:hover {
    color: #fff;
    background-color: #f44336;
}

.details-btn {
    color: #007bff;
    border-radius: 9px;
    padding: 3px;
}

.details-btn:hover {
    color: #fff;
    background-color: #31b0d5;
}

.status-btn {
    background-color: #007bff;
    margin-bottom: 10px;
}

.status-btn:hover {
    background-color: #0056b3;
}

.status-btns {
    border-radius: 9px;
    background-color: #007bff;
    transition: background-color 0.3s ease, transform 0.2s;
    color: white;
    margin: 10px;
    padding: 10px;
}

.status-btns:hover {
    background-color: #0056b3;
} /* Modal Styles */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

/* Modal Content Styles */
.modal-content {
    background: var(--clr-white);
    border-radius: var(--border-radius-3);
    color: var(--clr-dark);

    padding: var(--padding-1);
    width: 90%;
    max-width: 500px;
    box-shadow: var(--box-shadow);
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
}
/* Modal Button Container */
.modal-actions {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 20px;
}

/* Form Button Styles */
.save-btn {
    background-color: var(--clr-primary);
    color: var(--clr-white);
    border: none;
    padding: 10px 20px;
    border-radius: var(--border-radius-2);
    cursor: pointer;
    transition: background-color 0.3s;
}

.save-btn:hover {
    background-color: var(--clr-primary-variant);
}

.cancel-btn {
    background-color: var(--clr-danger);
    color: var(--clr-white);
    border: none;
    padding: 10px 20px;
    border-radius: var(--border-radius-2);
    cursor: pointer;
    transition: background-color 0.3s;
}

.cancel-btn:hover {
    background-color: var(--clr-danger-variant);
}
/* Responsive Styles */
@media (max-width: 1200px) {
    .content {
        max-width: 90%;
    }

    .form-container {
        padding: 20px;
    }
}

@media (max-width: 992px) {
    .containers {
        padding: 15px;
    }

    .profile-form {
        gap: 10px;
    }

    .save-btn {
        font-size: 14px;
    }

    .form-container {
        padding: 15px;
    }
}

@media (max-width: 768px) {
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

    .save-btn {
        padding: 8px 16px;
    }
}

@media (max-width: 576px) {
    body {
        font-size: 0.8rem;
    }

    .content {
        padding: 5px;
    }

    .input-with-buttons input,
    .input-with-buttons button {
        font-size: 0.875rem;
    }

    .input-with-buttons input {
        width: 100%;
        box-sizing: border-box;
    }

    .input-with-buttons button {
        width: 100%;
        margin-top: 5px;
    }

    .form-container {
        padding: 10px;
    }

    .profile-form {
        gap: 5px;
    }

    .description-input {
        width: 100%;
    }

    .modal-content {
        width: 95%;
        padding: var(--padding-1);
    }

    .modal-actions {
        flex-direction: column;
        align-items: stretch;
    }

    .modal-actions button {
        width: 100%;
        margin-top: 10px;
        font-size: 1rem;
    }

    .modal-actions button:first-child {
        margin-top: 0;
    }

    .nav-btnd {
        padding: 8px 16px;
        font-size: 10px;
    }

    .save-btn {
        padding: 5px 10px;
        font-size: 12px;
    }
}

/* Other Styles */

/* Button Styles */
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
.button-group button,
.add-field-btn,
.remove-field-btn {
    width: 100%;
    box-sizing: border-box;
}

.description-input {
    width: 100%;
    box-sizing: border-box;
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

.field-group input {
    flex: 1;
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    font-size: 1rem;
}

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

.add-field-btn:hover {
    background-color: var(--clr-primary-variant);
}

.remove-field-btn {
    background-color: var(--clr-danger);
}

.remove-field-btn:hover {
    background-color: var(--clr-danger-variant);
}

.material-icons {
    font-size: 20px;
    line-height: 1;
    align-items: center;
}

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
    font-size: 1rem;
    box-shadow: var(--box-shadow);
}

.category-container {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.category-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 10px;
    border: 1px solid var(--clr-info-dark);
    border-radius: var(--border-radius-1);
    background: var(--clr-light);
    width: 100%;
}

.category-item:hover {
    background: var(--clr-info-light);
}

.category-item .category-actions {
    display: flex;
    gap: 10px;
}

.category-item .category-actions .delete-btn {
    background: var(--clr-danger);
}

.category-item .category-actions .edit-btn {
    background: var(--clr-primary);
}

.category-actions button {
    padding: 5px;
    border-radius: var(--border-radius-1);
    color: var(--clr-white);
    border: none;
    cursor: pointer;
}

.category-actions button:hover {
    opacity: 0.8;
}

.modal-content {
    width: 90%;
    max-width: 500px;
    background: var(--clr-white);
    border-radius: var(--border-radius-3);
    padding: var(--padding-1);
    box-shadow: var(--box-shadow);
}

.modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}
</style>
