class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  validates :url,     presence: true
  validates :title,   presence: true

  # Needs to be rewritten : https://guides.rubyonrails.org/active_record_validations.html#performing-custom-validations
  # validates_url_format_of :url
end
