// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import mrujs from "mrujs"
import "./controllers"
import './datepicker'

window.Turbo = Turbo
mrujs.start()

// fontawesome
import { library, dom } from "@fortawesome/fontawesome-svg-core"
import {
    faArchive,
    faBars,
    faCalendarAlt,
    faCaretDown,
    faCaretRight,
    faExclamationTriangle,
    faExternalLinkAlt,
    faInfoCircle
    } from "@fortawesome/free-solid-svg-icons"

library.add(faArchive)
library.add(faBars)
library.add(faCalendarAlt)
library.add(faCaretDown)
library.add(faCaretRight)
library.add(faExclamationTriangle)
library.add(faExternalLinkAlt)
library.add(faInfoCircle)
dom.watch()
