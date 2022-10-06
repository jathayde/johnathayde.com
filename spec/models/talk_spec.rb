# frozen_string_literal: true

# == Schema Information
#
# Table name: talks
#
#  id                 :bigint           not null, primary key
#  description        :text             not null
#  slug               :string
#  speaker_deck_embed :string
#  subtitle           :string
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'rails_helper'

RSpec.describe Talk, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:talk)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:recordings).dependent(:destroy) }
    it { is_expected.to have_many(:appearances) }
  end

  describe 'validations' do
    # it "is invalid without an title"
    it { is_expected.to validate_presence_of(:title) }
    # it "is invalid without a description"
    it { is_expected.to validate_presence_of(:description) }
  end
end
