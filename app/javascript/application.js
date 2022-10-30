// Entry point for the build script in your package.json
import mrujs from "mrujs"
import "@hotwired/turbo-rails"

window.Turbo = Turbo
mrujs.start()

// import "./controllers"

// fontawesome
import { library, dom } from "@fortawesome/fontawesome-svg-core"
import {
         faArchive,
         faExternalLinkAlt,
         faCalendarAlt,
         faCaretRight,
         faBars,
         faCaretDown,
         faInfoCircle,
         faExclamationTriangle
       } from "@fortawesome/free-solid-svg-icons"
library.add(faArchive)
library.add(faExternalLinkAlt)
library.add(faCalendarAlt)
library.add(faCaretRight)
library.add(faBars)
library.add(faCaretDown)
library.add(faInfoCircle)
library.add(faExclamationTriangle)
dom.watch()

import './datepicker'
