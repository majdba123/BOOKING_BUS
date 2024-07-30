<template>
    <div class="containerd">
        <!-- Header with buttons -->
        <header class="navd">
            <button class="nav-btnd">Add Driver</button>
            <button class="nav-btnd">Edit Driver</button>
            <button class="nav-btnd">Button 3</button>
            <button class="nav-btnd">Button 4</button>
        </header>

        <div class="form-containerd">
            <form @submit.prevent="handleSubmit">
                <div class="form-groupd">
                    <label for="driverName">Driver Name</label>
                    <input
                        type="text"
                        id="driverName"
                        v-model="driverName"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverAge">Driver Age</label>
                    <input
                        type="number"
                        id="driverAge"
                        v-model="driverAge"
                        required
                    />
                </div>
                <div class="form-groupd">
                    <label for="driverLicense">Driver Number</label>
                    <input
                        type="text"
                        id="driverLicense"
                        v-model="driverLicense"
                        required
                    />
                </div>
                <div class="submit-btnnd">
                    <button type="submit" class="submit-btnd">Submit</button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
export default {
    name: "DriverManagement",
    data() {
        return {
            driverName: "",
            driverAge: "",
            driverLicense: "",
        };
    },
    methods: {
        handleSubmit() {
            console.log(
                "Form Submitted",
                this.driverName,
                this.driverAge,
                this.driverLicense
            );
            // Add your form submission logic here
        },
    },
};
</script>

<style scoped>
body,
html {
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
    height: 100%;
}

.containerd {
    width: 100%;
    margin-left: 20px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-size: cover;
    height: 100vh;
}

.navd {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
    width: 100%;
    margin-top: 20px;
    background-color: #fff;
    padding: 10px 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
}

.nav-btnd {
    padding: 10px 20px;
    border: none;
    border-radius: 25px;
    background: linear-gradient(90deg, #7380ec 0%, #111e88 100%);
    color: white;
    cursor: pointer;
    font-size: 12px;
    transition: transform 0.2s, box-shadow 0.2s;
    background-size: 200% 200%;
    animation: gradientAnimation 5s ease infinite;
}

@keyframes gradientAnimation {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.nav-btnd:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    transition: 0.3s ease;
}

.form-containerd {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    max-width: 400px;
    width: 100%;
    margin-top: 50px;
}

.form-groupd {
    margin-bottom: 15px;
    width: 100%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

input {
    width: 100%;
    padding: 10px;
    border: 2px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
    background-color: rgba(255, 255, 255, 0.6);
}

input:focus {
    border-color: #007bff;
}

.submit-btnnd {
    display: flex;
    justify-content: center;
}

.submit-btnd {
    padding: 10px 20px;
    border: none;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s;
}

.submit-btnd:hover {
    background-color: #0056b3;
}

/* Responsive Design */
@media (min-width: 600px) {
    .navd {
        justify-content: space-around;
    }
}
</style>
