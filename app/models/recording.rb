# frozen_string_literal: true

class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: %i[slugged finders]

  belongs_to :talk, optional: true
  belongs_to :appearance

  before_validation :set_slug

  validates :url,     presence: true
  validates :title,   presence: true

  # Needs to be rewritten : https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
  # validates_url_format_of :url

  private

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
