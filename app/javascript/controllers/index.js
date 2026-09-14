// Bare specifiers (resolved through the importmap) — relative "./" imports
// bypass the importmap and 404 against digested asset paths in production.
import { application } from "controllers/application"
import SortableController from "controllers/sortable_controller"
import CharCountController from "controllers/char_count_controller"
import SlugWarningController from "controllers/slug_warning_controller"

application.register("sortable", SortableController)
application.register("char-count", CharCountController)
application.register("slug-warning", SlugWarningController)
