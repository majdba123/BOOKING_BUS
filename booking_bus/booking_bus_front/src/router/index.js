import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import CreateCompany from "../views/CreateCompany.vue";
import AdminPage from "../views/AdminPage.vue";
import EditBreak from "../views/EditBreak.vue";
import AddGovernment from "../views/AddGovernment.vue";
import EditGovernment from "../views/EditGovernment.vue";
import UserPage from "../views/User/UserPage.vue";
import AllTripUser from "../views/User/AllTripUser.vue";
import AddPrivateTrip from "../views/User/AddPrivateTrip.vue";
import PrivateStatus from "../views/User/PrivateStatus.vue";
import BookingLogin from "../views/BookingLogin.vue";
import AllDriver2 from "../views/Company/Driver/AllDriver.vue";
import AllPath2 from "../views/Company/Path/AllPath.vue";
import AllBus2 from "../views/Company/Bus/AllBus.vue";
import AllTrip2 from "../views/Company/Trip/AllTrip.vue";
import ProfileCompany from "../views/Company/Profile/ProfilCompany.vue";
import AllBreak from "../views/Company/Break/AllBreak.vue";
import PrivateTrip from "../views/Company/PrivateTrip/PrivateTrip.vue";
import AllRating from "../views/Company/Rating/AllRating.vue";
import AllFavourite from "../views/Company/Favourite/AllFavourite.vue";
import AllPolices from "../views/Company/Polices/AllPolices.vue";
import AllReservation from "../views/Company/Reservation/AllReservation.vue";

const routes = [
    {
        path: "/",
        name: "home",
        component: HomeView,
    },
    {
        path: "/AllPolices",
        name: "AllPolices",
        component: AllPolices,
    },
    {
        path: "/AllReservation",
        name: "AllReservation",
        component: AllReservation,
    },
    {
        path: "/AllFavourite",
        name: "AllFavourite",
        component: AllFavourite,
    },
    {
        path: "/AllTrip2",
        name: "AllTrip2",
        component: AllTrip2,
    },
    {
        path: "/AllRating",
        name: "AllRating",
        component: AllRating,
    },
    {
        path: "/AllBus2",
        name: "AllBus2",
        component: AllBus2,
    },
    {
        path: "/PrivateTrip",
        name: "PrivateTrip",
        component: PrivateTrip,
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
        path: "/EditBreak",
        name: "EditBreak",
        component: EditBreak,
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
