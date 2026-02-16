import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button"]

  async copy() {
    const text = this.sourceTarget.textContent
    await navigator.clipboard.writeText(text)

    const btn = this.buttonTarget
    const original = btn.textContent
    btn.textContent = "Copied!"
    btn.classList.remove("bg-amber-600", "hover:bg-amber-500")
    btn.classList.add("bg-emerald-600", "hover:bg-emerald-500")

    setTimeout(() => {
      btn.textContent = original
      btn.classList.remove("bg-emerald-600", "hover:bg-emerald-500")
      btn.classList.add("bg-amber-600", "hover:bg-amber-500")
    }, 2000)
  }
}
