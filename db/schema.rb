# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_03_210113) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appearances", force: :cascade do |t|
    t.string "event", null: false
    t.date "date", null: false
    t.string "location", null: false
    t.string "who", null: false
    t.string "what", null: false
    t.text "notes"
    t.string "url"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "talk_id"
    t.bigint "recording_id"
    t.index ["recording_id"], name: "index_appearances_on_recording_id"
    t.index ["talk_id"], name: "index_appearances_on_talk_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "recordings", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.string "slug"
    t.date "recorded_on"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "talk_id"
    t.index ["talk_id"], name: "index_recordings_on_talk_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appearances", "recordings"
  add_foreign_key "appearances", "talks"
  add_foreign_key "recordings", "talks"
end
