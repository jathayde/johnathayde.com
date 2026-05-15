# frozen_string_literal: true

class CreateMusicRecordings < ActiveRecord::Migration[8.1]
  def change
    create_table :music_recordings do |t|
      t.references :artist, null: false, foreign_key: { to_table: :music_artists }

      t.string :title, null: false
      t.string :slug

      t.integer :release_year, null: false
      t.date    :release_date # optional finer-grained date; year is canonical

      t.string :kind, null: false, default: "album" # album/ep/single/compilation/soundtrack/remix/other

      t.string :john_role_override
      t.text   :notes

      t.string :spotify_url
      t.string :apple_music_url
      t.string :bandcamp_url
      t.string :soundcloud_url
      t.string :youtube_url

      t.text :embed_code # Bandcamp / Spotify embeds; admin-trusted

      t.timestamps
    end

    add_index :music_recordings, %i[artist_id slug], unique: true
    add_index :music_recordings, :release_year
  end
end
