# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppearanceType, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:appearance)).to be_valid
  end

  # it "is invalid without an title"
  it { is_expected.to validate_presence_of(:title) }
end
