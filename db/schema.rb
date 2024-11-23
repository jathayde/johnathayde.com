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

ActiveRecord::Schema[7.2].define(version: 2024_11_23_032829) do
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

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.string "author"
    t.text "body", null: false
    t.datetime "published_at"
    t.string "slug"
    t.text "page_title", null: false
    t.string "meta_description", limit: 155, null: false
    t.string "img_source"
    t.string "og_title"
    t.string "og_description"
    t.string "og_image"
    t.string "twitter_title"
    t.string "twitter_description"
    t.string "twitter_image"
    t.boolean "hidden_on_index", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
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

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
  add_foreign_key "taggings", "tags"
end
