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

ActiveRecord::Schema[7.0].define(version: 2022_10_06_002631) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appearance_types", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.bigint "appearance_type_id", null: false
    t.string "speaker_deck_override"
    t.index ["appearance_type_id"], name: "index_appearances_on_appearance_type_id"
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
    t.bigint "appearance_id", null: false
    t.boolean "embedded", default: false
    t.string "embed_host"
    t.text "embed_code"
    t.index ["appearance_id"], name: "index_recordings_on_appearance_id"
    t.index ["talk_id"], name: "index_recordings_on_talk_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle"
    t.string "speaker_deck_embed"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appearances", "appearance_types"
  add_foreign_key "appearances", "recordings"
  add_foreign_key "appearances", "talks"
  add_foreign_key "recordings", "appearances"
  add_foreign_key "recordings", "talks"
end
