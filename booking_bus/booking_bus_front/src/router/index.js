import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import CompanyPage from "../views/CompanyPage.vue";
import CreateDriver from "../views/CreateDriver.vue";
import CreateCompany from "../views/CreateCompany.vue";
import AdminPage from "../views/AdminPage.vue";
import AddPath from "../views/AddPath.vue";
import EditePath from "../views/EditePath.vue";
import AddBus from "../views/AddBus.vue";
import EditeBus from "../views/EditeBus.vue";
import BusStatus from "../views/BusStatus.vue";
import AllDriver from "../views/AllDriver.vue";
import DriverStatus from "../views/DriverStatus.vue";
import CancelDriver from "../views/CancelDriver.vue";
import DriverActive from "../views/DriverActive.vue";
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

const routes = [
    {
        path: "/",
        name: "home",
        component: HomeView,
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
        path: "/CancelDriver",
        name: "CancelDriver",
        component: CancelDriver,
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
        path: "/DriverActive",
        name: "DriverActive",
        component: DriverActive,
    },
    {
        path: "/DriverStatus",
        name: "DriverStatus",
        component: DriverStatus,
    },
    {
        path: "/AllDriver",
        name: "AllDriver",
        component: AllDriver,
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
    {
        path: "/AddBus",
        name: "AddBus",
        component: AddBus,
    },
    {
        path: "/BusStatus",
        name: "BusStatus",
        component: BusStatus,
    },
    {
        path: "/EditeBus",
        name: "EditeBus",
        component: EditeBus,
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
