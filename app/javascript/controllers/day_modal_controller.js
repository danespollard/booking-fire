import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this._frame = this.element.closest("turbo-frame")
    if (this._frame?.dataset.dayModalOpen) {
      delete this._frame.dataset.dayModalOpen
      this.dialogTarget.showModal()
    }
  }

  open(event) {
    event.stopPropagation()
    if (this.dialogTarget.contains(event.target)) return
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  disconnect() {
    if (this.dialogTarget.open && this._frame) {
      this._frame.dataset.dayModalOpen = "true"
    }
  }
}
