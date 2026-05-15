# frozen_string_literal: true

class CreateMusicArtists < ActiveRecord::Migration[8.1]
  def change
    create_table :music_artists do |t|
      t.string :name, null: false
      t.string :slug

      t.string :url

      t.string :instagram_url
      t.string :facebook_url
      t.string :twitter_url
      t.string :youtube_url
      t.string :bandcamp_url
      t.string :spotify_url
      t.string :apple_music_url
      t.string :soundcloud_url

      t.date :active_from
      t.date :active_to
      t.date :john_from
      t.date :john_to

      t.string :john_role

      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :music_artists, :slug, unique: true
    add_index :music_artists, :position
  end
end
