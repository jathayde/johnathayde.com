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
FactoryBot.define do
  factory :appearance_type do
    title { 'Conference' }
    slug { 'conference' }
  end
end
