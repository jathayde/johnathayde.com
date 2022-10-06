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
FactoryBot.define do
  factory :talk do
    title { 'A Talk About Talks' }
    description { Faker::Lorem.paragraph }
  end
end
