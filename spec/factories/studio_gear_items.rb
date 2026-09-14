# == Schema Information
#
# Table name: studio_gear_items
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  affiliate_url :string
#  blurb         :text
#  category      :string           default("misc"), not null
#  manufacturer  :string
#  name          :string           not null
#  position      :integer          default(0), not null
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_studio_gear_items_on_active                 (active)
#  index_studio_gear_items_on_category_and_position  (category,position)
#  index_studio_gear_items_on_slug                   (slug) UNIQUE
#
FactoryBot.define do
  factory :studio_gear_item, class: "Studio::GearItem" do
    sequence(:name) { |n| "Gear Item #{n}" }
    manufacturer { "Acme" }
    category     { "mics" }
    sequence(:position)
    active       { true }

    trait :affiliate do
      affiliate_url { "https://example.com/buy?ref=john" }
    end

    trait :inactive do
      active { false }
    end
  end
end
