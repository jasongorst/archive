const webpack = require('webpack')

module.exports = new webpack.ProvidePlugin({
  "$":"jquery",
  "jQuery":"jquery/src/jquery",
  "window.jQuery":"jquery"
});
