# frozen_string_literal: true

# == Schema Information
#
# Table name: music_artists
#
#  id              :bigint           not null, primary key
#  active_from     :date
#  active_to       :date
#  apple_music_url :string
#  bandcamp_url    :string
#  facebook_url    :string
#  instagram_url   :string
#  john_from       :date
#  john_role       :string
#  john_to         :date
#  name            :string           not null
#  position        :integer          default(0), not null
#  slug            :string
#  soundcloud_url  :string
#  spotify_url     :string
#  twitter_url     :string
#  url             :string
#  youtube_url     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_music_artists_on_position  (position)
#  index_music_artists_on_slug      (slug) UNIQUE
#
module Music
  class Artist < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: %i[slugged finders]

    has_one_attached :feature_photo
    has_rich_text :description

    has_many :recordings, -> { ordered }, class_name: "Music::Recording", dependent: :destroy
    has_many :videos, -> { ordered }, class_name: "Music::Video", dependent: :destroy

    validates :name, presence: true

    scope :ordered, -> { order(:position, :name) }

    SOCIAL_LINKS = %i[
      url
      instagram_url
      facebook_url
      twitter_url
      youtube_url
      bandcamp_url
      spotify_url
      apple_music_url
      soundcloud_url
    ].freeze

    def social_links
      SOCIAL_LINKS.each_with_object({}) do |key, memo|
        value = public_send(key)
        memo[key] = value if value.present?
      end
    end

    def to_param
      slug
    end
  end
end
