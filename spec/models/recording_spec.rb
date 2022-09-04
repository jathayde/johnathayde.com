# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recording, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:recording)).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:talk).optional }
    it { should belong_to(:appearance) }
  end

  describe 'validations' do
    # it "is invalid without a title"
    it { should validate_presence_of(:title) }

    # it "is invalid without a url"
    it { should validate_presence_of(:url) }

    it 'is invalid if the URL is not formatted properly'
  end
end
