# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: %i[slugged finders]

  has_many :articles, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
