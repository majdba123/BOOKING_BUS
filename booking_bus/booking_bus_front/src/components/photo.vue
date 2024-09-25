<template>
    <div class="profile-photo">
        <img v-if="company.logoURL" :src="company.logoURL" alt="Company Logo" />
    </div>
</template>
<script>
import axios from "axios";
import { mapActions } from "vuex";

export default {
    name: "ProfileCompanyLogo",
    data() {
        return {
            company: {
                logoURL: null,
            },
        };
    },
    methods: {
        ...mapActions(["updateCompanyName"]),

        fetchCompanyLogo() {
            const access_token = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/my_info", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.company.name = response.data.name;
                    this.company.logoURL = response.data.profile_image;
                    this.updateCompanyName(response.data.name);
                })
                .catch((error) => {
                    console.error(
                        "There was an error fetching the company logo:",
                        error
                    );
                });
        },
    },
    mounted() {
        this.fetchCompanyLogo();
    },
};
</script>
<style>
.profile-photo img {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    cursor: pointer;
}
</style>
