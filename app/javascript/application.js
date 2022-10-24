// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "bootstrap"

// fontawesome
import { library, dom } from "@fortawesome/fontawesome-svg-core"
import { faArchive,
         faExternalLinkAlt,
         faCalendarAlt,
         faCaretRight } from "@fortawesome/free-solid-svg-icons"
library.add(faArchive)
library.add(faExternalLinkAlt)
library.add(faCalendarAlt)
library.add(faCaretRight)
dom.watch()
