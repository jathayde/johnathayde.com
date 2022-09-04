class AppearanceType < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  validates :title, presence: true

  before_validation :set_slug

  private

  def set_slug
    self.slug ||= title.parameterize
  end
end
