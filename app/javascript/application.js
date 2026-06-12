// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import { highlightCode } from "lexxy"

// Lexxy highlights code inside the editor itself, but rendered Action Text
// content (blog post bodies) needs an explicit pass over pre[data-language].
document.addEventListener("turbo:load", () => highlightCode())
