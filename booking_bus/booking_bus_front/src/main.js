import { createApp } from "vue";
//import BookingLogin from "./views/BookingLogin.vue"; // Adjusted import path
//import AboutView from "./views/AboutView.vue";
import router from "./router";
import store from "./store";
import App from "./App.vue";
import Toast, { POSITION } from "vue-toastification";
import lottie from "lottie-web";

import "vue-toastification/dist/index.css";

const app = createApp(App);

app.use(store);
app.use(lottie);
app.use(Toast, {
    position: POSITION.TOP_RIGHT,
    timeout: 3000,
});
app.use(router);

app.mount("#app");
