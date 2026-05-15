# frozen_string_literal: true

# == Schema Information
#
# Table name: music_recordings
#
#  id                 :bigint           not null, primary key
#  apple_music_url    :string
#  bandcamp_url       :string
#  embed_code         :text
#  john_role_override :string
#  kind               :string           default("album"), not null
#  notes              :text
#  release_date       :date
#  release_year       :integer          not null
#  slug               :string
#  soundcloud_url     :string
#  spotify_url        :string
#  title              :string           not null
#  youtube_url        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  artist_id          :bigint           not null
#
# Indexes
#
#  index_music_recordings_on_artist_id           (artist_id)
#  index_music_recordings_on_artist_id_and_slug  (artist_id,slug) UNIQUE
#  index_music_recordings_on_release_year        (release_year)
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => music_artists.id)
#
module Music
  class Recording < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: %i[slugged finders scoped], scope: :artist

    KINDS = %w[album ep single compilation soundtrack remix other].freeze

    has_one_attached :cover_image

    belongs_to :artist, class_name: "Music::Artist"
    has_many :tracks, -> { ordered }, class_name: "Music::Track", dependent: :destroy

    validates :title, presence: true
    validates :release_year, presence: true,
                             numericality: { only_integer: true, greater_than: 1900, less_than: 2100 }
    validates :kind, inclusion: { in: KINDS }

    scope :ordered, -> { order(release_year: :desc, release_date: :desc, title: :asc) }

    def display_date
      release_date || Date.new(release_year, 1, 1)
    end

    def display_date_label
      release_date ? release_date.strftime("%b %-d, %Y") : release_year.to_s
    end

    def should_generate_new_friendly_id?
      title_changed? || super
    end
  end
end
