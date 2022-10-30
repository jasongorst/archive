import DateRangePicker from "flowbite-datepicker/DateRangePicker"

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
