<template>
    <form action="action_page.php">
        <div class="container">
            <h1>Register</h1>
            <p>Please fill in this form to create an account.</p>
            <hr />
            <label for="name"><b>name</b></label>
            <input
                type="text"
                placeholder="Enter name"
                name="name"
                id="name"
                required
                v-model="name"
            />
            <label for="email"><b>Email</b></label>
            <input
                type="text"
                placeholder="Enter Email"
                name="email"
                id="email"
                required
                v-model="email"
            />

            <label for="psw"><b>Password</b></label>
            <input
                type="password"
                placeholder="Enter Password"
                name="psw"
                id="psw"
                required
                v-model="password"
            />

            <hr />

            <p>
                By creating an account you agree to our
                <a href="#">Terms & Privacy</a>.
            </p>

            <button @click="register()" class="registerbtn">Register</button>
        </div>

        <div class="container signin">
            <p>Already have an account? <a href="#">Sign in</a>.</p>
        </div>
    </form>
</template>

<script>
// @ is an alias to /src
import axios from "axios";

export default {
    name: "HomeView",
    components: {},
    methods: {
        register: function () {
            axios({
                method: "post",
                url: "http://127.0.0.1:8000/api/register",
                data: {
                    name: this.name,
                    email: this.email,
                    password: this.password,
                },
            })
                .then(function (response) {
                    console.log(response);

                    window.alert(" regestir succesful");
                })
                .catch(function (error) {
                    console.log(error);

                    window.alert(error.response.message);
                });
        },
    },
};
</script>
<style scoped>
* {
    box-sizing: border-box;
}

/* Add padding to containers */
.container {
    padding: 16px;
}

/* Full-width input fields */
input[type="text"],
input[type="password"] {
    width: 100%;
    padding: 15px;
    margin: 5px 0 22px 0;
    display: inline-block;
    border: none;
    background: #f1f1f1;
}

input[type="text"]:focus,
input[type="password"]:focus {
    background-color: #ddd;
    outline: none;
}

/* Overwrite default styles of hr */
hr {
    border: 1px solid #f1f1f1;
    margin-bottom: 25px;
}

/* Set a style for the submit/register button */
.registerbtn {
    background-color: #04aa6d;
    color: white;
    padding: 16px 20px;
    margin: 8px 0;
    border: none;
    cursor: pointer;
    width: 100%;
    opacity: 0.9;
}

.registerbtn:hover {
    opacity: 1;
}

/* Add a blue text color to links */
a {
    color: dodgerblue;
}

/* Set a grey background color and center the text of the "sign in" section */
.signin {
    background-color: #f1f1f1;
    text-align: center;
}
</style>
