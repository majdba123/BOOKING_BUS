<template>
    <div>
        <img v-if="company.logoURL" :src="company.logoURL" alt="Company Logo" />
    </div>
</template>
<script>
import axios from "axios";

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
        fetchCompanyLogo() {
            const access_token = window.localStorage.getItem("access_token");
            axios
                .get("http://127.0.0.1:8000/api/company/my_info", {
                    headers: { Authorization: `Bearer ${access_token}` },
                })
                .then((response) => {
                    this.company.logoURL = response.data.profile_image;
                })
                .catch((error) => {
                    console.error(
                        "There was an error fetching the company logo:",
                        error
                    );
                });
            console.log(this.company.logoURL);
        },
    },
    mounted() {
        this.fetchCompanyLogo();
    },
};
</script>
<style></style>
