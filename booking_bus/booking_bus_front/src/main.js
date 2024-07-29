import { createApp } from "vue";
//import BookingLogin from "./views/BookingLogin.vue"; // Adjusted import path
// import BookingLogin from "./views/BookingLogin.vue";
import router from "./router";
import store from "./store";
import App from "./App.vue";

const app = createApp(App);

app.use(store).use(router).mount("#app");
