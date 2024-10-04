const { defineConfig } = require("@vue/cli-service");
module.exports = defineConfig({
    transpileDependencies: true,
    devServer: {
        overlay: {
            warnings: false,
            errors: false,
        },
    },
});
