module.exports = {
    content: [
        './public/*.html',
        './app/assets/stylesheets/**/*.css',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/views/**/*.{erb,haml,html,slim}',
        './node_modules/flowbite-datepicker/**/*.js'
    ],
    plugins: [
        require("daisyui"),
    ],
    darkMode: 'media',
    daisyui: {
        themes: ["winter", "night"],
        darkTheme: "night"
    }
}
