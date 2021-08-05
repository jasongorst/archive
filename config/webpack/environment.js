const { environment } = require('@rails/webpacker')
const jquery = require('./plugins/jquery')

const webpack = require("webpack");
environment.plugins.prepend(
    "Provide",
    new webpack.ProvidePlugin({
        $: "jquery/src/jquery",
        Popper: "popper.js/dist/popper",
        moment: "moment/moment"
    })
);

environment.plugins.prepend('jquery', jquery)
module.exports = environment
