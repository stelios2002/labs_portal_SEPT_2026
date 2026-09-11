import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["count"]
  static values = { count: Number }

  connect() {
    this.consumer = createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      { channel: "NotificationsChannel" },
      { received: () => this.increment() }
    )
  }

  disconnect() {
    this.subscription?.unsubscribe()
  }

  increment() {
    this.countValue++
    this.countTarget.textContent = this.countValue
  }
}