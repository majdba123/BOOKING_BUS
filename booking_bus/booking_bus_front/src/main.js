import { createApp } from "vue";
import router from "./router";
import store from "./store";
import EditePath from "./views/EditePath.vue";

const app = createApp(EditePath);
app.use(store).use(router).mount("#app");
