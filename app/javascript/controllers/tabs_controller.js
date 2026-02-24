import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: String, inactive: String }

  connect() {
    this.showIndex(0)
  }

  select(event) {
    const index = this.tabTargets.indexOf(event.currentTarget)
    this.showIndex(index)
  }

  showIndex(index) {
    this.tabTargets.forEach((tab, i) => {
      tab.dataset.active = i === index ? "true" : "false"
    })
    this.panelTargets.forEach((panel, i) => {
      panel.hidden = i !== index
    })
  }
}
