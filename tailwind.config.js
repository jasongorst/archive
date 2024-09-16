import daisyui from "daisyui"
import themes from "daisyui/src/theming/themes"
import tailwindTypography from "@tailwindcss/typography"
import flowbite from "flowbite/plugin"

export default {
  content: [
    "./public/*.html",
    "./app/assets/stylesheets/*.css",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./node_modules/flowbite/**/*.js"
  ],
  plugins: [
    daisyui,
    tailwindTypography
  ],
  daisyui: {
    themes: [
      // first theme is the default (for light mode)
      "winter",
      {
        dark: {
          ...themes["dark"],
          primary: "#661AE6",
          "primary-content": "#ffffff",
          secondary: "#D926AA",
          accent: "#1FB2A5",
          "accent-content": "#ffffff"
        }
      }
    ],
    darkMode: "media",
    darkTheme: "dark",
    logs: false
  }
}
