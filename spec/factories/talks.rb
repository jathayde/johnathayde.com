FactoryBot.define do
  factory :talk do
    title { "A Talk About Talks" }
    description { Faker::Lorem.paragraph }
  end
end