# frozen_string_literal: true

class CreateMusicVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :music_videos do |t|
      t.references :artist, null: false, foreign_key: { to_table: :music_artists }

      t.string :title, null: false
      t.string :kind, null: false, default: "music_video" # music_video/live/interview/other
      t.date   :performed_on
      t.string :url, null: false
      t.text   :embed_code # optional; for cases where the URL parser isn't enough
      t.text   :notes

      t.timestamps
    end

    add_index :music_videos, :performed_on
  end
end
