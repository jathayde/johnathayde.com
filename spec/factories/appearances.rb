FactoryBot.define do
  factory :appearance do
    event { "MyString" }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    location { "MyString" }
    who { "MyString" }
    what { "MyString" }
    notes { Faker::Lorem.paragraph }
    url { "MyString" }
    slug { "MyString" }
  end
end
