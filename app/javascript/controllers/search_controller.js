import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [
    "channels",
    "channelsCheckboxSm",
    "channelsCheckboxLg",
    "channelsSelect",
    "allChannels",
    "allChannelsCheckboxSm",
    "allChannelsCheckboxLg",
    "allChannelsSelect",
    "order",
    "bestMatch",
    "date",
    "newestFirst",
    "oldestFirst"
  ]

  connect() {
    if (this.bestMatchTarget.checked) {
      this.orderTarget.hidden = true
    }
  }

  handleChannelsCheckbox(event) {
    let showArchived = event.target.checked
    this.setChannelCheckboxes(showArchived)

    this.channelsTarget.hidden = showArchived
    this.allChannelsTarget.hidden = !showArchived
  }

  setChannelCheckboxes(checkedState) {
    const checkboxTargets = [
      this.channelsCheckboxSmTarget,
      this.channelsCheckboxLgTarget,
      this.allChannelsCheckboxSmTarget,
      this.allChannelsCheckboxLgTarget
    ]

    for (let target of checkboxTargets) {
      target.checked = checkedState
    }
  }

  handleChannelsSelect(event) {
    let selectedChannel = this.getSelectedOptionValue(this.channelsSelectTarget)
    this.setSelectedOptionByValue(this.allChannelsSelectTarget, selectedChannel)
  }

  handleAllChannelsSelect(event) {
    let selectedChannel = this.getSelectedOptionValue(this.allChannelsSelectTarget)
    this.setSelectedOptionByValue(this.channelsSelectTarget, selectedChannel)
  }

  handleSortBy() {
    let sortByBestMatch = this.bestMatchTarget.checked
    this.orderTarget.hidden = sortByBestMatch
    this.newestFirstTarget.checked = !sortByBestMatch
    this.oldestFirstTarget.checked = sortByBestMatch
  }

  getSelectedOptionValue(target) {
    return target.selectedOptions.item(0).value
  }

  setSelectedOptionByValue(target, value) {
    for (let option of target.options) {
      option.selected = (option.value === value)
    }
  }
}
