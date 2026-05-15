# frozen_string_literal: true

# == Schema Information
#
# Table name: music_videos
#
#  id           :bigint           not null, primary key
#  embed_code   :text
#  kind         :string           default("music_video"), not null
#  notes        :text
#  performed_on :date
#  title        :string           not null
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  artist_id    :bigint           not null
#
# Indexes
#
#  index_music_videos_on_artist_id     (artist_id)
#  index_music_videos_on_performed_on  (performed_on)
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => music_artists.id)
#
module Music
  class Video < ApplicationRecord
    KINDS = %w[music_video live interview other].freeze

    belongs_to :artist, class_name: "Music::Artist"

    validates :title, presence: true
    validates :url, presence: true
    validates :kind, inclusion: { in: KINDS }

    scope :ordered, -> { order(Arel.sql("performed_on IS NULL"), performed_on: :desc, title: :asc) }
  end
end
