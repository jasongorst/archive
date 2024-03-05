import "@hotwired/turbo-rails"
import "flowbite/dist/datepicker.turbo.js"
import mrujs from "mrujs"
import "./controllers"

window.Turbo = Turbo
mrujs.start()

// fontawesome
import { library, dom } from "@fortawesome/fontawesome-svg-core"
import {
    faBars,
    faBoxArchive,
    faCalendarAlt,
    faCaretDown,
    faCaretRight,
    faExclamationTriangle,
    faExternalLinkAlt,
    faInfoCircle
    } from "@fortawesome/free-solid-svg-icons"

library.add(faBars)
library.add(faBoxArchive)
library.add(faCalendarAlt)
library.add(faCaretDown)
library.add(faCaretRight)
library.add(faExclamationTriangle)
library.add(faExternalLinkAlt)
library.add(faInfoCircle)
dom.watch()
