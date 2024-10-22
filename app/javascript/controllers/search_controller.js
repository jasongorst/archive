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
    "hiddenShowArchived",
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

    let showArchived = (this.hiddenShowArchivedTarget.value === "1")
    this.setShowArchivedStates(showArchived)
  }

  handleChannelsCheckbox(event) {
    let showArchived = event.target.checked
    this.setShowArchivedStates(showArchived)

    if (!showArchived && (this.getChannelsSelectValue() !== this.getAllChannelsSelectValue())) {
      this.setSelectToFirstOption(this.allChannelsSelectTarget)
    }
  }

  setShowArchivedStates(showArchived) {
    this.setChannelCheckboxes(showArchived)
    this.setChannelSelectsHidden(showArchived)
    this.hiddenShowArchivedTarget.value = showArchived ? "1" : "0"
  }

  setChannelCheckboxes(showArchived) {
    const checkboxTargets = [
      this.channelsCheckboxSmTarget,
      this.channelsCheckboxLgTarget,
      this.allChannelsCheckboxSmTarget,
      this.allChannelsCheckboxLgTarget
    ]

    for (let target of checkboxTargets) {
      target.checked = showArchived
    }
  }

  setChannelSelectsHidden(showArchived) {
    this.channelsTarget.hidden = showArchived
    this.allChannelsTarget.hidden = !showArchived
  }

  handleChannelsSelect(event) {
    this.setSelectedOptionByValue(this.allChannelsSelectTarget, this.getChannelsSelectValue())
  }

  handleAllChannelsSelect(event) {
    this.setSelectedOptionByValue(this.channelsSelectTarget, this.getAllChannelsSelectValue())
  }

  handleSortBy() {
    let sortByBestMatch = this.bestMatchTarget.checked
    this.orderTarget.hidden = sortByBestMatch
    this.newestFirstTarget.checked = !sortByBestMatch
    this.oldestFirstTarget.checked = sortByBestMatch
  }

  getChannelsSelectValue() {
    return this.getSelectedOptionValue(this.channelsSelectTarget)
  }

  getAllChannelsSelectValue() {
    return this.getSelectedOptionValue(this.allChannelsSelectTarget)
  }

  getSelectedOptionValue(target) {
    return target.selectedOptions.item(0).value
  }

  setSelectedOptionByValue(target, value) {
    for (let option of target.options) {
      option.selected = (option.value === value)
    }
  }

  setSelectToFirstOption(target) {
    target.selectedIndex = 0
  }
}
