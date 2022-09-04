# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Appearance, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:appearance)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:appearance_type) }
    it { should belong_to(:talk).optional }
    it { should have_many(:recordings).dependent(:destroy) }
  end

  describe 'validations' do
    # it "is invalid without an event"
    it { should validate_presence_of(:event) }
    # it "is invalid without a date"
    it { should validate_presence_of(:date) }
    # it "is invalid without a location"
    it { should validate_presence_of(:location) }
    # it "is invalid without noting who is appearing"
    it { should validate_presence_of(:who) }
    # it "is invalid without noting what they're speaking about"
    it { should validate_presence_of(:what) }
  end
end
