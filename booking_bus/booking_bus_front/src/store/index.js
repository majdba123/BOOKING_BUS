import { createStore } from "vuex";

export default createStore({
    state: {
        breacklat: null,
        breacklong: null,
        x: "Dashboard",
        Bus: {},
        Driver: {},
        Company: {},
        Paths: {},
        Trips: {},
        Government: {},
        searchQuery: "",
        Profile: "",
        start: null,
        end: null,
        startLat: null,
        startLng: null,
        endLat: null,
        endLng: null,
        distance: null,
        placeName: null,
        lat: null,
        lng: null,
    },
    getters: {},
    mutations: {
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
        setDistance(state, distance) {
            state.distance = distance;
        },
        resetPoint(state) {
            state.pointLat = null;
            state.pointLng = null;
            state.distance = null;
        },
        setStartCoordinates(state, payload) {
            state.startLat = payload.lat;
            state.startLng = payload.lng;
        },
        setEndCoordinates(state, payload) {
            state.endLat = payload.lat;
            state.endLng = payload.lng;
        },
        resetCoordinates(state) {
            state.startLat = null;
            state.startLng = null;
            state.endLat = null;
            state.endLng = null;
        },
    },
    actions: {
        updateBreakLocation({ commit }, { lat, lng }) {
            commit('setBreakLat', lat);
            commit('setBreakLong', lng);
        },
    },
    modules: {},
});
