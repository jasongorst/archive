// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
Rails.start()
ActiveStorage.start()

import "bootstrap"

// fontawesome
import { library, icon, dom } from "@fortawesome/fontawesome-svg-core"
import { faArchive, faExternalLinkAlt, faCalendarAlt } from "@fortawesome/free-solid-svg-icons"
library.add(faArchive)
library.add(faExternalLinkAlt)
library.add(faCalendarAlt)
dom.watch()
