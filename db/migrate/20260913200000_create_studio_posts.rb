# frozen_string_literal: true

class CreateStudioPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :studio_posts do |t|
      t.string   :title, null: false
      t.string   :slug
      t.string   :summary, null: false
      t.string   :category, null: false, default: "tracking" # tracking/audio_post/podcast/video
      t.string   :status, null: false, default: "draft"      # draft/published
      t.string   :youtube_id
      t.text     :verdict
      t.text     :signal_chain
      t.datetime :published_at

      # SEO overrides; each falls back to a content field when blank.
      t.string :meta_title
      t.string :meta_description, limit: 160
      t.string :og_image
      t.string :canonical_url

      t.timestamps
    end

    add_index :studio_posts, :slug, unique: true
    add_index :studio_posts, :status
    add_index :studio_posts, :published_at
  end
end
