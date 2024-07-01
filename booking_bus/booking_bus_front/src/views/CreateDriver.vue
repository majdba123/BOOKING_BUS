<template>
    <div class="main-content">
        <NavBarCompany />
        <div class="content">
            <div class="title">Add Driver</div>
            <div class="box">
                <div class="box2"></div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBarCompany from "@/components/NavBarCompany.vue";

export default { name: "CreateDriver", components: { NavBarCompany } };
</script>
<style lang="scss">
* {
}
.main-content {
    display: flex;
    width: 100%;
}
.content {
    display: block;
}
.title {
    margin: 30px;
    padding: 20px;
    background-color: #2f3234;
    border-radius: 15px;
    text-align: center;
    font-size: 26px;
}
.box {
    display: flex;
    margin: 30px;
    padding: 20px;
    background-color: #2f3234;
    border-radius: 15px;
    text-align: center;
    font-size: 26px;
}
.box2 {
    display: block;
}
</style>
