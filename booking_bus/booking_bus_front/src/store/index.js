import { createStore } from "vuex";

export default createStore({
    state: {
        startLat: null,
        startLng: null,
        endLat: null,
        endLng: null,
        breacklat1: null, // نقطة التوقف الأولى
        breacklong1: null, // نقطة التوقف الأولى
        breacklat2: null, // نقطة التوقف الثانية
        breacklong2: null, // نقطة التوقف الثانية
        distance: null, // المسافة الكلية
        User: {},
        routeDistance: null, // تخزين المسافة هنا
        breacklat: null,
        breacklong: null,
        x: "Dashboard",
        companyName: "",
        Bus: {},
        Driver: [],
        Company: {},
        Paths: {},
        Trips: {},
        Government: {},
        searchQuery: "",
        message: [],
        Profile: "",
        start: null,
        end: null,
        selectedLat: null,
        selectedLng: null,
        placeName: null,
        lat: null,
        lng: null,
        Users: {},
        lattrack: null,
        langtrack: null,
        additionalBreaks: [],
    },
    getters: {
        getStartCoordinates: (state) => {
            return { lat: state.startLat, lng: state.startLng };
        },
        getEndCoordinates: (state) => {
            return { lat: state.endLat, lng: state.endLng };
        },
        getBreakCoordinates1: (state) => {
            return { lat: state.breacklat1, lng: state.breacklong1 };
        },
        getBreakCoordinates2: (state) => {
            return { lat: state.breacklat2, lng: state.breacklong2 };
        },
        getDistance: (state) => {
            return state.distance;
        },
        getNotifications: (state) => state.message,
        getCompanyName: (state) => state.companyName,
    },
    mutations: {
        setEndCoordinates(state, payload) {
            state.endLat = payload.lat;
            state.endLng = payload.lng;
        },
        setBreakCoordinates1(state, payload) {
            state.breacklat1 = payload.lat;
            state.breacklong1 = payload.lng;
        },
        setBreakCoordinates2(state, payload) {
            state.breacklat2 = payload.lat;
            state.breacklong2 = payload.lng;
        },
        setDistance(state, distance) {
            state.distance = distance;
        },
        resetCoordinates(state) {
            state.startLat = null;
            state.startLng = null;
            state.endLat = null;
            state.endLng = null;
            state.breacklat1 = null;
            state.breacklong1 = null;
            state.breacklat2 = null;
            state.breacklong2 = null;
            state.routeDistance = null; // تخزين المسافة هنا
        },
        setStartCoordinates(state, payload) {
            state.startLat = payload.lat;
            state.startLng = payload.lng;
        },
        SET_COMPANY_NAME(state, name) {
            state.companyName = name;
        },
        ADD_TRAKING(state, lattrack, langtrack) {
            state.lattrack = lattrack;
            state.langtrack = langtrack;
        },
        ADD_NOTIFICATION(state, message) {
            state.message.push(message);
        },
        updateSearchQuery(state, newQuery) {
            state.searchQuery = newQuery;
        },
        setBreakLat(state, lat) {
            state.breacklat = lat;
        },
        setBreakLong(state, lng) {
            state.breacklong = lng;
        },
        setPlaceData(state, { name, lat, lng }) {
            state.placeName = name;
            state.lat = lat;
            state.lng = lng;
        },
        resetPlaceData(state) {
            state.placeName = null;
            state.lat = null;
            state.lng = null;
        },
        setPointCoordinates(state, { lat, lng }) {
            state.pointLat = lat;
            state.pointLng = lng;
        },

        resetPoint(state) {
            state.pointLat = null;
            state.pointLng = null;
            state.distance = null;
        },
    },
    actions: {
        resetAll({ commit }) {
            commit("resetCoordinates");
        },
        updateCompanyName({ commit }, name) {
            commit("SET_COMPANY_NAME", name);
        },
        addNotification({ commit }, message) {
            commit("ADD_NOTIFICATION", message);
        },
        updateBreakLocation({ commit }, { lat, lng }) {
            commit("setBreakLat", lat);
            commit("setBreakLong", lng);
        },
    },
    modules: {},
});
