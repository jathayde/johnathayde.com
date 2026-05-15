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

ActiveRecord::Schema[8.1].define(version: 2026_05_15_030003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appearance_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "slug"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "appearances", force: :cascade do |t|
    t.bigint "appearance_type_id", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "event", null: false
    t.string "location", null: false
    t.text "notes"
    t.bigint "recording_id"
    t.string "slug"
    t.string "speaker_deck_override"
    t.bigint "talk_id"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "what", null: false
    t.string "who", null: false
    t.index ["appearance_type_id"], name: "index_appearances_on_appearance_type_id"
    t.index ["recording_id"], name: "index_appearances_on_recording_id"
    t.index ["talk_id"], name: "index_appearances_on_talk_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "author"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.boolean "hidden_on_index", default: false
    t.string "img_source"
    t.string "meta_description", limit: 155, null: false
    t.string "og_description"
    t.string "og_image"
    t.string "og_title"
    t.text "page_title", null: false
    t.datetime "published_at"
    t.string "slug"
    t.string "subtitle"
    t.string "title", null: false
    t.string "twitter_description"
    t.string "twitter_image"
    t.string "twitter_title"
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "music_artists", force: :cascade do |t|
    t.date "active_from"
    t.date "active_to"
    t.string "apple_music_url"
    t.string "bandcamp_url"
    t.datetime "created_at", null: false
    t.string "facebook_url"
    t.string "instagram_url"
    t.date "john_from"
    t.string "john_role"
    t.date "john_to"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "slug"
    t.string "soundcloud_url"
    t.string "spotify_url"
    t.string "twitter_url"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "youtube_url"
    t.index ["position"], name: "index_music_artists_on_position"
    t.index ["slug"], name: "index_music_artists_on_slug", unique: true
  end

  create_table "music_recordings", force: :cascade do |t|
    t.string "apple_music_url"
    t.bigint "artist_id", null: false
    t.string "bandcamp_url"
    t.datetime "created_at", null: false
    t.text "embed_code"
    t.string "john_role_override"
    t.string "kind", default: "album", null: false
    t.text "notes"
    t.date "release_date"
    t.integer "release_year", null: false
    t.string "slug"
    t.string "soundcloud_url"
    t.string "spotify_url"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "youtube_url"
    t.index ["artist_id", "slug"], name: "index_music_recordings_on_artist_id_and_slug", unique: true
    t.index ["artist_id"], name: "index_music_recordings_on_artist_id"
    t.index ["release_year"], name: "index_music_recordings_on_release_year"
  end

  create_table "music_tracks", force: :cascade do |t|
    t.string "apple_music_url"
    t.string "bandcamp_url"
    t.datetime "created_at", null: false
    t.string "john_role"
    t.text "notes"
    t.bigint "recording_id", null: false
    t.string "spotify_url"
    t.string "title", null: false
    t.integer "track_number"
    t.datetime "updated_at", null: false
    t.string "youtube_url"
    t.index ["recording_id", "track_number"], name: "index_music_tracks_on_recording_id_and_track_number"
    t.index ["recording_id"], name: "index_music_tracks_on_recording_id"
  end

  create_table "music_videos", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.text "embed_code"
    t.string "kind", default: "music_video", null: false
    t.text "notes"
    t.date "performed_on"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["artist_id"], name: "index_music_videos_on_artist_id"
    t.index ["performed_on"], name: "index_music_videos_on_performed_on"
  end

  create_table "recordings", force: :cascade do |t|
    t.bigint "appearance_id", null: false
    t.datetime "created_at", null: false
    t.text "embed_code"
    t.string "embed_host"
    t.boolean "embedded", default: false
    t.text "notes"
    t.date "recorded_on"
    t.string "slug"
    t.bigint "talk_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["appearance_id"], name: "index_recordings_on_appearance_id"
    t.index ["talk_id"], name: "index_recordings_on_talk_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.string "taggable_type"
    t.bigint "tagger_id"
    t.string "tagger_type"
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
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "taggings_count", default: 0
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "talks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "slug"
    t.string "speaker_deck_embed"
    t.string "subtitle"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appearances", "appearance_types"
  add_foreign_key "appearances", "recordings"
  add_foreign_key "appearances", "talks"
  add_foreign_key "music_recordings", "music_artists", column: "artist_id"
  add_foreign_key "music_tracks", "music_recordings", column: "recording_id"
  add_foreign_key "music_videos", "music_artists", column: "artist_id"
  add_foreign_key "recordings", "appearances"
  add_foreign_key "recordings", "talks"
  add_foreign_key "taggings", "tags"
end
