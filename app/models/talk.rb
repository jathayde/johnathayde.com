# frozen_string_literal: true

# == Schema Information
#
# Table name: talks
#
#  id                 :bigint           not null, primary key
#  description        :text             not null
#  slug               :string
#  speaker_deck_embed :string
#  subtitle           :string
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Talk < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: %i[slugged finders]

  has_one_attached :cover_image
  has_one_attached :deck

  has_many :recordings, dependent: :destroy
  has_many :appearances, dependent: :destroy

  before_validation :set_slug

  validates :title,       presence: true
  validates :description, presence: true

  private

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
