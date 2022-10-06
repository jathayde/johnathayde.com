# frozen_string_literal: true

# == Schema Information
#
# Table name: recordings
#
#  id            :bigint           not null, primary key
#  embed_code    :text
#  embed_host    :string
#  embedded      :boolean          default(FALSE)
#  notes         :text
#  recorded_on   :date
#  slug          :string
#  title         :string           not null
#  url           :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  appearance_id :bigint           not null
#  talk_id       :bigint
#
# Indexes
#
#  index_recordings_on_appearance_id  (appearance_id)
#  index_recordings_on_talk_id        (talk_id)
#
# Foreign Keys
#
#  fk_rails_...  (appearance_id => appearances.id)
#  fk_rails_...  (talk_id => talks.id)
#
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
