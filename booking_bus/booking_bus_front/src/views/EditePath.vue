<template>
    <div class="continer">
        <table class="table">
            <thead>
                <tr>
                    <th>Name Path</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Damascus</td>
                    <td>
                        <button>
                            <router-link to="">Delete</router-link>
                        </button>
                    </td>
                    <td>
                        <button>
                            <router-link to="">Edit</router-link>
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
export default {
    name: "EditePath",
};
</script>

<style scoped>
* {
    margin: 0;
    padding: 0;
    outline: none;
    border: none;
    text-decoration: none;
    box-sizing: border-box;
    font-family: "Poppins", sans-serif;
}
.continer {
    width: 70%;
    margin: 20px auto;
    text-align: center;
}

.table {
    border-collapse: collapse;
    table-layout: fixed;
    width: 100%;
    font-size: 13px;
    min-width: 100%;
    overflow: hidden;
    border-radius: 4px;
    margin: 35px auto;
}

.table thead tr {
    background: #176b87;
    text-align: left;
    font-weight: bold;
    color: white;
}

.table th,
.table td {
    padding: 12px 15px;
    text-align: center;
    word-break: break-all;
}

.table th {
    color: white;
}

.table td {
    color: #000000;
    background: #e9e9e9;
}

.table button {
    padding: 6px 20px;
    border-radius: 10px;
    cursor: pointer;
    color: #fff;
    background-color: #176b87;
    border: 1px solid #ffffff;
}

.table button a {
    color: #fff;
}

.table button:hover {
    background: #204e5e;
    color: #fff;
    transition: 0.5s;
}

tr td a {
    color: #000000;
}

tr td a:hover,
.dd:hover {
    color: #ffffff;
}

.dd {
    color: #000000;
}
</style>
