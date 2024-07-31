<template>
    <main>
        <h1>{{ x }}</h1>
        <div class="top-bar">
            <div class="date">
                <input
                    type="text"
                    placeholder="Search In..."
                    aria-label="Search"
                />
                <button>Search</button>
            </div>
        </div>
    </main>
</template>
<script>
import store from "@/store";
export default {
    name: "HeaderCompany",
    data() {
        return {
            x: store.state.x,
        };
    },
    methods: {
        openMenu() {
            const sideMenu = this.$refs.sideMenu;
            if (sideMenu) {
                sideMenu.style.display = "block";
            }
        },
        closeMenu() {
            const sideMenu = this.$refs.sideMenu;
            if (sideMenu) {
                sideMenu.style.display = "none";
            }
        },
        toggleTheme() {
            const themeToggler = this.$refs.themeToggler;
            if (themeToggler) {
                themeToggler
                    .querySelector("span:nth-child(1)")
                    .classList.toggle("active");
                themeToggler
                    .querySelector("span:nth-child(2)")
                    .classList.toggle("active");
            }
        },
    },
    mounted() {},
    components: {},
};
</script>
<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap");

:root {
    --clr-primary: #7380ec;
    --clr-danger: #ff7782;
    --clr-success: #41f1b6;
    --clr-white: #fff;
    --clr-info-dark: #7d8da1;
    --clr-info-light: #e4e9f7;
    --clr-dark: #363949;
    --clr-warning: #ffbb55;
    --clr-light: rgba(132, 139, 200, 0.18);
    --clr-primary-variant: #111e88;
    --clr-dark-variant: #677483;
    --clr-color-background: #f6f6f9;

    --card-border-radius: 2rem;
    --border-radius-1: 0.4rem;
    --border-radius-2: 0.8rem;
    --border-radius-3: 1.2rem;

    --card-padding: 1.8rem;
    --padding-1: 1.2rem;

    box-shadow: 0 2rem 3rem rgba(132, 139, 200, 0.18);
}
.dark-theme-variables {
    --clr-color-background: #181a1e;
    --clr-white: #202528;
    --clr-light: rgba(0, 0, 0, 0.4);
    --clr-dark: #edeffd;
    --clr-dark-variant: #677483;
    --box-shadow: 0 2rem 3rem var(--clr-light);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    text-decoration: none;
    border: 0;
    list-style: none;
    appearance: none;
}

body {
    font-family: "Poppins", sans-serif;
    width: 100%;
    height: 100%;
    overflow: hidden;
    font-size: 0.88rem;
    user-select: none;
    overflow-x: hidden;
    background: #f6f6f9;
}

.container {
    display: grid;
    width: 100%;
    gap: 1.8rem;
    grid-template-columns: 14rem auto 14rem;
    margin-left: 0;
}

a {
    color: #363949;
}

h1 {
    font-weight: 800;
    font-size: 1.8rem;
}

h2 {
    font-size: 1.4rem;
}

h3 {
    font-size: 0.87rem;
}

h4 {
    font-size: 0.8rem;
}

h5 {
    font-size: 0.77rem;
}

small {
    font-size: 0.75rem;
}

input {
    background-color: transparent;
    border: 0;
    outline: 0;
    color: #363949;
    width: 930px !important;
}

.top-bar {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.date {
    display: inline-block;
    background-color: #fff;
    border-radius: 0.9rem;
    padding: 9px;
    margin-top: 9px;
}

.date button {
    padding: 0.5rem 1rem;
    border: none;
    background-color: #007bff;
    color: #fff;
    border-radius: 1rem;
    cursor: pointer;
    margin-left: 5px;
}

.date button:hover {
    background-color: #0056b3;
    transition: 0.4s ease-in;
}

/* Responsive Design */
@media screen and (max-width: 1200px) {
    input {
        width: 100%;
    }
}

@media screen and (max-width: 768px) {
    .container {
        width: 100%;
        grid-template-columns: repeat(1, 1fr);
    }

    input {
        width: auto !important;
        max-width: 100%;
        min-width: 200px;
    }

    .date {
        display: flex;
        flex-direction: column;
        align-items: stretch;
    }

    .date button {
        margin-top: 10px;
        width: 100%;
    }
}

@media screen and (max-width: 500px) {
    input {
        width: 100%;
        font-size: 0.75rem;
    }

    .date {
        padding: 5px;
    }

    .date button {
        font-size: 0.75rem;
        padding: 0.4rem 0.8rem;
    }
}
</style>
