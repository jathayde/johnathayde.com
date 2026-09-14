# frozen_string_literal: true

# == Schema Information
#
# Table name: studio_posts
#
#  id               :bigint           not null, primary key
#  canonical_url    :string
#  category         :string           default("tracking"), not null
#  meta_description :string(160)
#  meta_title       :string
#  og_image         :string
#  published_at     :datetime
#  signal_chain     :text
#  slug             :string
#  status           :string           default("draft"), not null
#  summary          :string           not null
#  title            :string           not null
#  verdict          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  youtube_id       :string
#
# Indexes
#
#  index_studio_posts_on_published_at  (published_at)
#  index_studio_posts_on_slug          (slug) UNIQUE
#  index_studio_posts_on_status        (status)
#
module Studio
  class Post < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: %i[slugged finders]

    META_DESCRIPTION_LIMIT = 160

    enum :category, {
      tracking: "tracking",
      audio_post: "audio_post",
      podcast: "podcast",
      video: "video"
    }, default: :tracking

    CATEGORY_LABELS = {
      "tracking" => "Tracking",
      "audio_post" => "Audio Post",
      "podcast" => "Podcast",
      "video" => "Video"
    }.freeze

    enum :status, { draft: "draft", published: "published" }, default: :draft

    has_rich_text :body
    has_one_attached :hero_image do |attachable|
      attachable.variant :card, resize_to_fill: [800, 450]
      attachable.variant :hero, resize_to_fill: [1600, 900]
      attachable.variant :og,   resize_to_fill: [1200, 630]
    end

    has_many :audio_samples, -> { ordered }, class_name: "Studio::AudioSample", dependent: :destroy
    has_many :post_gear_items, class_name: "Studio::PostGearItem", dependent: :destroy
    has_many :gear_items, -> { ordered }, through: :post_gear_items, class_name: "Studio::GearItem"

    before_validation :normalize_slug
    before_validation :default_published_at

    validates :title, presence: true
    validates :summary, presence: true, length: { maximum: 500 }
    validates :body, presence: true
    validates :youtube_id, format: { with: /\A[\w-]{11}\z/, message: "must be an 11-character YouTube video ID" },
                           allow_blank: true
    validates :meta_description, length: { maximum: META_DESCRIPTION_LIMIT }
    validates :published_at, presence: true, if: :published?
    validates :canonical_url, format: { with: %r{\Ahttps?://\S+\z}i, message: "must be an http(s) URL" },
                              allow_blank: true
    validates :og_image, format: { with: %r{\Ahttps?://\S+\z}i, message: "must be an http(s) URL" },
                         allow_blank: true

    # Live = published status AND publish time reached (a future published_at
    # is a scheduled post, hidden from the public until then).
    scope :live, -> { published.where(published_at: ..Time.current) }
    scope :visible_on_index, -> { live.order(published_at: :desc) }

    def live?
      published? && published_at.present? && published_at <= Time.current
    end

    def scheduled?
      published? && published_at.present? && published_at.future?
    end

    def category_label
      CATEGORY_LABELS.fetch(category, category.to_s.humanize)
    end

    # SEO fallbacks: each override is optional and defers to the content.
    def meta_title_or_title
      meta_title.presence || title
    end

    def meta_description_or_summary
      meta_description.presence || summary.to_s.truncate(META_DESCRIPTION_LIMIT)
    end

    def youtube_embed_url
      "https://www.youtube-nocookie.com/embed/#{youtube_id}" if youtube_id.present?
    end

    def youtube_watch_url
      "https://www.youtube.com/watch?v=#{youtube_id}" if youtube_id.present?
    end

    def youtube_thumbnail_url
      "https://i.ytimg.com/vi/#{youtube_id}/hqdefault.jpg" if youtube_id.present?
    end

    # A blank slug in the admin form means "generate from the title"; a
    # filled-in one is kept verbatim.
    def should_generate_new_friendly_id?
      slug.blank?
    end

    private

    def normalize_slug
      self.slug = slug.presence && slug.parameterize
    end

    def default_published_at
      self.published_at ||= Time.current if published?
    end
  end
end
