<script>
import axios from "axios";

export default {
    name: "NotificationComponent",
    data() {
        return {
            Notification: [],
            company_id: null,
        };
    },
    methods: {
        notification() {
            const access_token = window.localStorage.getItem("access_token");
            const company_id =
                this.company_id || window.localStorage.getItem("company_id");

            axios({
                method: "get",
                url: `http://127.0.0.1:8000/api/my_notification/${company_id}`,
                headers: { Authorization: `Bearer ${access_token}` },
            })
                .then((response) => {
                    this.Notification = response.data;
                    console.log(response.data);
                })
                .catch((error) => {
                    this.toast.error("Error getting Notification.");
                    console.error(error);
                });
            this.loading = true;
        },
    },
    mounted() {
        this.notification();
    },
};
</script>
