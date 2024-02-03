import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import viteCompression from "vite-plugin-compression"

export default defineConfig(({ command}) => {
  if (command === "serve") {
    return {
      // development
      css: {
        devSourcemap: true
      },
      plugins: [
        RubyPlugin()
      ]
    }
  } else {
    return {
      // production
      build: {
        assetsInlineLimit: 0,
        emptyOutDir: true
      },
      plugins: [
        RubyPlugin(),
        viteCompression({
          algorithm: "gzip",
          ext: ".gz",
          threshold: 1280
        }),
        viteCompression({
          algorithm: "brotliCompress",
          ext: ".br",
          threshold: 1280
        })
      ]
    }
  }
})
