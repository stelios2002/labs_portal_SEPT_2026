import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wrapper"]

  open() {
    this.wrapperTarget.style.display = "block"
  }

  close() {
    this.wrapperTarget.style.display = "none"
  }
}