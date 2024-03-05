module.exports = {
  content: [
    "./public/*.html",
    "./app/assets/stylesheets/*.css",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./node_modules/flowbite/**/*.js"
  ],
  plugins: [
    require("daisyui")
  ],
  darkMode: "media",
  daisyui: {
    themes: [
      "winter",
      {
        dark: {
          ...require("daisyui/src/theming/themes")["dark"],
          primary: "#661AE6",
          "primary-content": "#ffffff",
          secondary: "#D926AA",
          accent: "#1FB2A5",
          "accent-content": "#ffffff"
        }
      }
    ],
    logs: false
  }
}
