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

import DateRangePicker from 'flowbite-datepicker/DateRangePicker'

var getDatepickerOptions = function getDatepickerOptions(datepickerEl) {
    var buttons = datepickerEl.hasAttribute('datepicker-buttons')
    var autohide = datepickerEl.hasAttribute('datepicker-autohide')
    var format = datepickerEl.hasAttribute('datepicker-format')
    var orientation = datepickerEl.hasAttribute('datepicker-orientation')
    var title = datepickerEl.hasAttribute('datepicker-title')
    var options = {}

    if (buttons) {
        options.todayBtn = true
        options.clearBtn = true
    }

    if (autohide) {
        options.autohide = true
    }

    if (format) {
        options.format = datepickerEl.getAttribute('datepicker-format')
    }

    if (orientation) {
        options.orientation = datepickerEl.getAttribute('datepicker-orientation')
    }

    if (title) {
        options.title = datepickerEl.getAttribute('datepicker-title')
    }

    return options
}

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[datepicker]').forEach(function (datepickerEl) {
        new Datepicker(datepickerEl, getDatepickerOptions(datepickerEl))
    })

    document.querySelectorAll('[inline-datepicker]').forEach(function (datepickerEl) {
        new Datepicker(datepickerEl, getDatepickerOptions(datepickerEl))
    })

    document.querySelectorAll('[date-rangepicker]').forEach(function (datepickerEl) {
        new DateRangePicker(datepickerEl, getDatepickerOptions(datepickerEl))
    })
})

document.addEventListener('turbo:render', () => {
    document.querySelectorAll('[datepicker]').forEach(function (datepickerEl) {
        new Datepicker(datepickerEl, getDatepickerOptions(datepickerEl))
    })

    document.querySelectorAll('[inline-datepicker]').forEach(function (datepickerEl) {
        new Datepicker(datepickerEl, getDatepickerOptions(datepickerEl))
    })

    document.querySelectorAll('[date-rangepicker]').forEach(function (datepickerEl) {
        new DateRangePicker(datepickerEl, getDatepickerOptions(datepickerEl))
    })
})
