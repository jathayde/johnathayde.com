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
require 'rails_helper'

RSpec.describe AppearanceType, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:appearance)).to be_valid
  end

  # it "is invalid without an title"
  it { is_expected.to validate_presence_of(:title) }
end
