import { createApp } from "vue";
import BookingLogin from "./views/BookingLogin.vue";
import router from "./router";
import store from "./store";

const app = createApp(BookingLogin);

app.use(store).use(router).mount("#app");
