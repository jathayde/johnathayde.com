import { Controller } from "@hotwired/stimulus"

// Shows a warning when the slug of an already-published record is edited,
// since the old URL will stop resolving.
//
// Usage:
//   <div data-controller="slug-warning"
//        data-slug-warning-original-value="<%= post.slug %>"
//        data-slug-warning-published-value="<%= post.published? %>">
//     <input data-slug-warning-target="input" data-action="input->slug-warning#check">
//     <p data-slug-warning-target="warning" hidden>…</p>
//   </div>
export default class extends Controller {
  static targets = ["input", "warning"]
  static values = { original: String, published: Boolean }

  check() {
    const changed = this.inputTarget.value.trim() !== this.originalValue
    this.warningTarget.hidden = !(this.publishedValue && changed)
  }
}
