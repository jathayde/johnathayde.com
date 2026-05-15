import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Drag-to-reorder list. Wraps an element whose children carry `data-id`
// attributes; PATCHes the new id order to `data-sortable-url-value` on drop.
//
// Usage:
//   <ol data-controller="sortable"
//       data-sortable-url-value="<%= reorder_admin_music_artists_path %>">
//     <li data-id="<%= artist.id %>"> ... </li>
//   </ol>
export default class extends Controller {
  static values = { url: String, handle: { type: String, default: ".drag-handle" } }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: this.handleValue,
      ghostClass: "sortable-ghost",
      onEnd: this.save.bind(this)
    })
  }

  disconnect() {
    this.sortable?.destroy()
    this.sortable = null
  }

  async save() {
    const ids = Array.from(this.element.querySelectorAll("[data-id]")).map(el => el.dataset.id)
    const token = document.querySelector('meta[name="csrf-token"]')?.content

    const response = await fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": token || ""
      },
      body: JSON.stringify({ ids })
    })

    if (!response.ok) {
      console.error("Reorder failed:", response.status, await response.text())
    }
  }
}
