// Bare specifiers (resolved through the importmap) — relative "./" imports
// bypass the importmap and 404 against digested asset paths in production.
import { application } from "controllers/application"
import SortableController from "controllers/sortable_controller"

application.register("sortable", SortableController)
