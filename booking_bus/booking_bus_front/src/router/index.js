import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import CompanyPage from "../views/CompanyPage.vue";
import CreateDriver from "../views/CreateDriver.vue";
import CreateCompany from "../views/CreateCompany.vue";
import AdminPage from "../views/AdminPage.vue";
import AddPath from "../views/AddPath.vue";
import EditePath from "../views/EditePath.vue";

const routes = [
    {
        path: "/",
        name: "home",
        component: HomeView,
    },
    {
        path: "/AdminPage",
        name: "AdminPage",
        component: AdminPage,
    },
    {
        path: "/CreateCompany",
        name: "CreateCompany",
        component: CreateCompany,
    },
    {
        path: "/CompanyPage",
        name: "CompanyPage",
        component: CompanyPage,
    },
    {
        path: "/CreateDriver",
        name: "CreateDriver",
        component: CreateDriver,
    },
    {
        path: "/AddPath",
        name: "AddPath",
        component: AddPath,
    },
    { path: "/EditePath", name: "EditePath", component: EditePath },
    {
        path: "/about",
        name: "about",
        // route level code-splitting
        // this generates a separate chunk (about.[hash].js) for this route
        // which is lazy-loaded when the route is visited.
        component: () =>
            import(/* webpackChunkName: "about" */ "../views/AboutView.vue"),
    },
];

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes,
});

export default router;
