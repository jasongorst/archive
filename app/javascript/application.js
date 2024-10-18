import "@hotwired/turbo-rails"
import "flowbite/dist/flowbite.turbo.js"
import "./controllers"

window.Turbo = Turbo

// fontawesome
import { library, dom } from "@fortawesome/fontawesome-svg-core"
import {
    faBars,
    faBoxArchive,
    faCalendarAlt,
    faCaretDown,
    faCaretRight,
    faCircleUser as fasCircleUser,
    faExclamationTriangle,
    faExternalLinkAlt,
    faInfoCircle
    } from "@fortawesome/free-solid-svg-icons"
import { faCircleUser as farCircleUser } from "@fortawesome/free-regular-svg-icons"

library.add(faBars)
library.add(faBoxArchive)
library.add(faCalendarAlt)
library.add(faCaretDown)
library.add(faCaretRight)
library.add(faExclamationTriangle)
library.add(faExternalLinkAlt)
library.add(faInfoCircle)
library.add(farCircleUser)
library.add(fasCircleUser)
dom.watch()
