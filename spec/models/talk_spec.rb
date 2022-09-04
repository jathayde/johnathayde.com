# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Talk, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:talk)).to be_valid
  end

  describe 'associations' do
    it { should have_many(:recordings).dependent(:destroy) }
    it { should have_many(:appearances) }
  end

  describe 'validations' do
    # it "is invalid without an title"
    it { should validate_presence_of(:title) }
    # it "is invalid without a description"
    it { should validate_presence_of(:description) }
  end
end
