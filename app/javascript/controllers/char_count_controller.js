import { Controller } from "@hotwired/stimulus"

// Live character counter for a text field with a target range, e.g. a meta
// description that should land between 150 and 160 characters.
//
// Usage:
//   <div data-controller="char-count" data-char-count-min-value="150" data-char-count-max-value="160">
//     <textarea data-char-count-target="input" data-action="input->char-count#update"></textarea>
//     <span data-char-count-target="counter"></span>
//   </div>
export default class extends Controller {
  static targets = ["input", "counter"]
  static values = { min: Number, max: Number }

  connect() {
    this.update()
  }

  update() {
    const length = this.inputTarget.value.length
    this.counterTarget.textContent = `${length} / ${this.maxValue} characters`
    this.counterTarget.classList.toggle("over", length > this.maxValue)
    this.counterTarget.classList.toggle("under", length > 0 && length < this.minValue)
    this.counterTarget.classList.toggle("in-range", length >= this.minValue && length <= this.maxValue)
  }
}
