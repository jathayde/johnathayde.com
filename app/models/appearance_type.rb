# frozen_string_literal: true

class AppearanceType < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: %i[slugged finders]

  has_many :appearances

  before_validation :set_slug

  validates :title, presence: true

  private

  def set_slug
    self.slug ||= title.parameterize
  end
end
