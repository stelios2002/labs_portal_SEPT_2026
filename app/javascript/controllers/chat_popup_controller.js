import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wrapper", "frame"]

  connect() {
    this.frameTarget.addEventListener("turbo:frame-render", () => this.open())
  }

  open() {
    this.wrapperTarget.style.display = "block"
  }

  close() {
    this.wrapperTarget.style.display = "none"
  }
}