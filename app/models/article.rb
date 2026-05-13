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

  validates :title, presence: true
  validates :body, presence: true
  validates :page_title, presence: true
  validates :meta_description, presence: true, length: { maximum: 155 }

  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }
  scope :visible_on_index, -> { published.where(hidden_on_index: false).order(published_at: :desc) }

  def published?
    published_at.present? && published_at <= Time.current
  end
end
