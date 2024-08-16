import { createStore } from "vuex";

export default createStore({
    state: {
        x: "Dashboard",
        Bus: {},
        Driver: {},
        Paths: {},
        Trips: {},
        searchQuery: "",
        Profile: "",
        start: null,
        end: null,
    },
    getters: {},
    mutations: {
        updateSearchQuery(state, newQuery) {
            state.searchQuery = newQuery;
        },
        setStart(state, location) {
            state.start = location;
        },
        setEnd(state, location) {
            state.end = location;
        },
        resetPoints(state) {
            state.start = null;
            state.end = null;
        },
    },
    actions: {},
    modules: {},
});
