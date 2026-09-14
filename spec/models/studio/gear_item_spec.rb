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
#  quantity      :integer          default(1), not null
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
require 'rails_helper'

RSpec.describe Studio::GearItem, type: :model do
  it "requires a name and defaults to the misc category" do
    expect(described_class.new).not_to be_valid
    expect(described_class.new(name: "Thing")).to be_misc
  end

  it "builds its display name and slug from manufacturer and name" do
    item = FactoryBot.create(:studio_gear_item, manufacturer: "Neumann", name: "U 87 Ai")
    expect(item.display_name).to eq("Neumann U 87 Ai")
    expect(item.slug).to eq("neumann-u-87-ai")
  end

  it "regenerates the slug when renamed" do
    item = FactoryBot.create(:studio_gear_item, manufacturer: "Shure", name: "SM57")
    item.update!(name: "SM7B")
    expect(item.slug).to eq("shure-sm7b")
  end

  it "defaults quantity to 1 and labels only multiples" do
    item = FactoryBot.build(:studio_gear_item)
    expect(item.quantity).to eq(1)
    expect(item.quantity_label).to be_nil
    item.quantity = 2
    expect(item.quantity_label).to eq("2×")
    item.quantity = 0
    expect(item).not_to be_valid
  end

  it "validates the affiliate URL scheme" do
    expect(FactoryBot.build(:studio_gear_item, affiliate_url: "ftp://nope")).not_to be_valid
    expect(FactoryBot.build(:studio_gear_item, :affiliate)).to be_valid
    expect(FactoryBot.build(:studio_gear_item, :affiliate)).to be_affiliate
    expect(FactoryBot.build(:studio_gear_item)).not_to be_affiliate
  end

  it "offers every signal-chain category" do
    expect(described_class.categories.keys).to eq(
      %w[mics preamps compressors converters monitoring outboard instruments synths amplifiers software video misc]
    )
    expect(described_class::CATEGORY_LABELS.keys).to match_array(described_class.categories.keys)
  end

  describe ".grouped_for_display" do
    it "groups active items by category in signal-chain order, dropping empty groups" do
      out = FactoryBot.create(:studio_gear_item, category: "monitoring", position: 0)
      mic2 = FactoryBot.create(:studio_gear_item, category: "mics", position: 2)
      mic1 = FactoryBot.create(:studio_gear_item, category: "mics", position: 1)
      FactoryBot.create(:studio_gear_item, :inactive, category: "preamps")

      expect(described_class.grouped_for_display).to eq([["mics", [mic1, mic2]], ["monitoring", [out]]])
    end
  end
end
