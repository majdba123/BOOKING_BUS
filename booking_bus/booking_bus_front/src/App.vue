<template>
    <div>
        <NavBar />
        <router-view></router-view>
    </div>
</template>

<script>
import NavBar from "./components/NavBar.vue";

export default {
    components: {
        NavBar,
    },
};
</script>

<style>
/* أنماط CSS الخاصة بك هنا */
</style>
