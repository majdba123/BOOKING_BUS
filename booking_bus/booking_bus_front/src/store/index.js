import { createStore } from "vuex";

export default createStore({
    state: { x: "Dashboard", Driver: {}, searchQuery: "" },
    getters: {},
    mutations: {
        updateSearchQuery(state, newQuery) {
            state.searchQuery = newQuery;
        },
    },
    actions: {},
    modules: {},
});
