# == Schema Information
#
# Table name: articles
#
#  id                  :bigint           not null, primary key
#  author              :string
#  body                :text             not null
#  hidden_on_index     :boolean          default(FALSE)
#  img_source          :string
#  meta_description    :string(155)      not null
#  og_description      :string
#  og_image            :string
#  og_title            :string
#  page_title          :text             not null
#  published_at        :datetime
#  slug                :string
#  subtitle            :string
#  title               :string           not null
#  twitter_description :string
#  twitter_image       :string
#  twitter_title       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  enum :status, { draft: "draft", published: "published" }, default: :draft

  belongs_to :category, optional: true
  acts_as_taggable_on :tags
  has_rich_text :body
  has_one_attached :feature_image do |attachable|
    attachable.variant :card, resize_to_fill: [800, 450]
    attachable.variant :hero, resize_to_limit: [1600, 900]
    attachable.variant :og,   resize_to_fill: [1200, 630]
  end

  before_validation :default_published_at

  validates :title, presence: true
  validates :body, presence: true
  validates :page_title, presence: true
  validates :meta_description, presence: true, length: { maximum: 155 }
  validates :published_at, presence: true, if: :published?
  validates :canonical_url, format: { with: %r{\Ahttps?://}i, message: "must be an http(s) URL" },
                            allow_blank: true

  # Live = published status AND publish time reached (a future published_at
  # is a scheduled post, hidden from the public until then).
  scope :live, -> { published.where(published_at: ..Time.current) }
  scope :visible_on_index, -> { live.where(hidden_on_index: false).order(published_at: :desc) }

  def live?
    published? && published_at.present? && published_at <= Time.current
  end

  def scheduled?
    published? && published_at.present? && published_at.future?
  end

  private

  def default_published_at
    self.published_at ||= Time.current if published?
  end
end
