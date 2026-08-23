module.exports = {
    preset: "@vue/cli-plugin-unit-jest",
    testEnvironment: "jsdom",
    moduleNameMapper: {
        "^axios$": "<rootDir>/node_modules/axios/dist/node/axios.cjs",
    },
};
