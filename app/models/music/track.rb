# frozen_string_literal: true

# == Schema Information
#
# Table name: music_tracks
#
#  id              :bigint           not null, primary key
#  apple_music_url :string
#  bandcamp_url    :string
#  john_role       :string
#  notes           :text
#  spotify_url     :string
#  title           :string           not null
#  track_number    :integer
#  youtube_url     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  recording_id    :bigint           not null
#
# Indexes
#
#  index_music_tracks_on_recording_id                   (recording_id)
#  index_music_tracks_on_recording_id_and_track_number  (recording_id,track_number)
#
# Foreign Keys
#
#  fk_rails_...  (recording_id => music_recordings.id)
#
module Music
  class Track < ApplicationRecord
    belongs_to :recording, class_name: "Music::Recording"

    has_one :artist, through: :recording

    validates :title, presence: true

    scope :ordered, -> { order(Arel.sql("track_number IS NULL"), :track_number, :title) }
  end
end
