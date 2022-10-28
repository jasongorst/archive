module.exports = {
    content: [
        './app/views/**/*.html.haml',
        './app/helpers/**/*.rb',
        './app/assets/stylesheets/**/*.css',
        './app/javascript/**/*.js',
        './node_modules/flowbite-datepicker/**/*.js'
    ],
    plugins: [
        require("daisyui"),
    ],
    darkMode: 'media',
    daisyui: {
        darkTheme: "night",
        themes: ["winter", "night"],
    }
}
