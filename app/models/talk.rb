# frozen_string_literal: true

class Talk < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: %i[slugged finders]

  has_one_attached :cover_image
  has_one_attached :deck

  has_many :recordings, dependent: :destroy
  has_many :appearances

  before_validation :set_slug

  validates :title,       presence: true
  validates :description, presence: true

  private

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
