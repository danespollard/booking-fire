import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.outsideClickHandler = this.closeOnOutsideClick.bind(this)
  }

  toggle(event) {
    if (event.target.closest("form")) return

    event.stopPropagation()
    if (this.menuTarget.hidden) {
      this.menuTarget.hidden = false
      const rect = this.element.getBoundingClientRect()
      this.menuTarget.style.position = "fixed"
      this.menuTarget.style.top = `${rect.bottom + 4}px`
      this.menuTarget.style.left = `${rect.left}px`
      document.addEventListener("click", this.outsideClickHandler)
    } else {
      this.close()
    }
  }

  close() {
    this.menuTarget.hidden = true
    document.removeEventListener("click", this.outsideClickHandler)
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickHandler)
  }
}
