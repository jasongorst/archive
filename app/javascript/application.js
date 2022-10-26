// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// fontawesome
import { library, dom } from "@fortawesome/fontawesome-svg-core"
import {
         faArchive,
         faExternalLinkAlt,
         faCalendarAlt,
         faCaretRight,
         faBars,
         faCaretDown,
       } from "@fortawesome/free-solid-svg-icons"
library.add(faArchive)
library.add(faExternalLinkAlt)
library.add(faCalendarAlt)
library.add(faCaretRight)
library.add(faBars)
library.add(faCaretDown)
dom.watch()
