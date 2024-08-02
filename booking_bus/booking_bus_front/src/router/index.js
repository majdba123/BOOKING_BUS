import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import CompanyPage from "../views/CompanyPage.vue";
import CreateCompany from "../views/CreateCompany.vue";
import AdminPage from "../views/AdminPage.vue";
import EditePath from "../views/EditePath.vue";
import AllBus from "../views/AllBus.vue";
import AddBreak from "../views/AddBreak.vue";
import EditBreak from "../views/EditBreak.vue";
import AddGovernment from "../views/AddGovernment.vue";
import EditGovernment from "../views/EditGovernment.vue";
import AddTrip from "../views/AddTrip.vue";
import AllTrip from "../views/AllTrip.vue";
import TripStatus from "../views/TripStatus.vue";
import UserPage from "../views/User/UserPage.vue";
import AllTripUser from "../views/User/AllTripUser.vue";
import AddPrivateTrip from "../views/User/AddPrivateTrip.vue";
import PrivateStatus from "../views/User/PrivateStatus.vue";
import BookingLogin from "../views/BookingLogin.vue";
import AllDriver2 from "../views/Company/Driver/AllDriver.vue";
import AllPath2 from "../views/Company/Path/AllPath.vue";
import AllBus2 from "../views/Company/Bus/AllBus.vue";
import ProfileCompany from "../views/Company/Profile/ProfilCompany.vue";
import AllBreak from "../views/Company/Break/AllBreak.vue";

const routes = [
    {
        path: "/",
        name: "home",
        component: HomeView,
    },
    {
        path: "/AllBus2",
        name: "AllBus2",
        component: AllBus2,
    },
    {
        path: "/AllBreak",
        name: "AllBreak",
        component: AllBreak,
    },
    {
        path: "/ProfileCompany",
        name: "ProfileCompany",
        component: ProfileCompany,
    },
    {
        path: "/AllPath2",
        name: "AllPath2",
        component: AllPath2,
    },
    {
        path: "/AllDriver2",
        name: "AllDriver2",
        component: AllDriver2,
    },
    {
        path: "/PrivateStatus",
        name: "PrivateStatus",
        component: PrivateStatus,
    },
    {
        path: "/AddPrivateTrip",
        name: "AddPrivateTrip",
        component: AddPrivateTrip,
    },
    {
        path: "/AllTripUser",
        name: "AllTripUser",
        component: AllTripUser,
    },
    {
        path: "/UserPage",
        name: "UserPage",
        component: UserPage,
    },
    {
        path: "/TripStatus",
        name: "TripStatus",
        component: TripStatus,
    },
    {
        path: "/AllTrip",
        name: "AllTrip",
        component: AllTrip,
    },
    {
        path: "/AddTrip",
        name: "AddTrip",
        component: AddTrip,
    },
    {
        path: "/BookingLogin",
        name: "BookingLogin",
        component: BookingLogin,
    },
    {
        path: "/AddGovernment",
        name: "AddGovernment",
        component: AddGovernment,
    },
    {
        path: "/EditGovernment",
        name: "EditGovernment",
        component: EditGovernment,
    },
    {
        path: "/EditBreak",
        name: "EditBreak",
        component: EditBreak,
    },
    {
        path: "/AddBreak",
        name: "AddBreak",
        component: AddBreak,
    },
    {
        path: "/EditBreak",
        name: "EditBreak",
        component: EditBreak,
    },
    {
        path: "/AllBus",
        name: "AllBus",
        component: AllBus,
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
