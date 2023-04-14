import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [ "order", "best", "date", "newest", "oldest" ]
  connect() {
    if (this.bestTarget.checked == true) {
      this.orderTarget.hidden = true
    }
  }

  update() {
    if (this.dateTarget.checked == true) {
      this.orderTarget.hidden = false
    } else {
      this.orderTarget.hidden = true
      this.newestTarget.checked = true
      this.oldestTarget.checked = false
    }
  }
}
