# frozen_string_literal: true

class CreateMusicTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :music_tracks do |t|
      t.references :recording, null: false, foreign_key: { to_table: :music_recordings }

      t.string  :title, null: false
      t.integer :track_number
      t.string  :john_role
      t.text    :notes

      t.string :spotify_url
      t.string :apple_music_url
      t.string :bandcamp_url
      t.string :youtube_url

      t.timestamps
    end

    add_index :music_tracks, %i[recording_id track_number]
  end
end
