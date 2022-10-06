# frozen_string_literal: true

# == Schema Information
#
# Table name: appearance_types
#
#  id         :bigint           not null, primary key
#  slug       :string
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AppearanceType < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: %i[slugged finders]

  has_many :appearances, dependent: :destroy

  before_validation :set_slug

  validates :title, presence: true

  private

  def set_slug
    self.slug ||= title.parameterize
  end
end
