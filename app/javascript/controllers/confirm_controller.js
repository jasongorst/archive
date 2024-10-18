import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirm"
export default class extends Controller {
  leave(event) {
    if (!window.confirm(event.params.prompt)) {
      event.preventDefault()
    }
  }
}
