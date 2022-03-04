// config/webpack/custom.js
module.exports = {
    resolve: {
        alias: {
            Popper: ['@popperjs/core', 'default']
        },
        extensions: ['.css', '.scss']
    }
}
