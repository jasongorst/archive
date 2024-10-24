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
    "hiddenIncludeArchived",
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

    let includeArchived = (this.hiddenIncludeArchivedTarget.value === "1")
    this.setIncludeArchivedStates(includeArchived)
  }

  handleChannelsCheckbox(event) {
    let includeArchived = event.target.checked
    this.setIncludeArchivedStates(includeArchived)

    if (!includeArchived && (this.getChannelsSelectValue() !== this.getAllChannelsSelectValue())) {
      this.setSelectToFirstOption(this.allChannelsSelectTarget)
    }
  }

  setIncludeArchivedStates(includeArchived) {
    this.setChannelCheckboxes(includeArchived)
    this.setChannelSelectsHidden(includeArchived)
    this.hiddenIncludeArchivedTarget.value = includeArchived ? "1" : "0"
  }

  setChannelCheckboxes(includeArchived) {
    const checkboxTargets = [
      this.channelsCheckboxSmTarget,
      this.channelsCheckboxLgTarget,
      this.allChannelsCheckboxSmTarget,
      this.allChannelsCheckboxLgTarget
    ]

    for (let target of checkboxTargets) {
      target.checked = includeArchived
    }
  }

  setChannelSelectsHidden(includeArchived) {
    this.channelsTarget.hidden = includeArchived
    this.allChannelsTarget.hidden = !includeArchived
  }

  handleChannelsSelect(_) {
    this.setSelectedOptionByValue(this.allChannelsSelectTarget, this.getChannelsSelectValue())
  }

  handleAllChannelsSelect(_) {
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
