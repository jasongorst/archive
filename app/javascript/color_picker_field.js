import Coloris from "@melloware/coloris"

document.addEventListener("turbo:load", (_) => init_coloris())
init_coloris()

function init_coloris() {
  Coloris.init()

  Coloris({
    el: ".color-picker",
    format: "hex",
    themeMode: "light",
    theme: "large",
    alpha: false,
    clearButton: true
  })

  Coloris.wrap()
}
