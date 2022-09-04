# frozen_string_literal: true

FactoryBot.define do
  factory :talk do
    title { 'A Talk About Talks' }
    description { Faker::Lorem.paragraph }
  end
end
