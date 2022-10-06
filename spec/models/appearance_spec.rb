# frozen_string_literal: true

# == Schema Information
#
# Table name: appearances
#
#  id                    :bigint           not null, primary key
#  date                  :date             not null
#  event                 :string           not null
#  location              :string           not null
#  notes                 :text
#  slug                  :string
#  speaker_deck_override :string
#  url                   :string
#  what                  :string           not null
#  who                   :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  appearance_type_id    :bigint           not null
#  recording_id          :bigint
#  talk_id               :bigint
#
# Indexes
#
#  index_appearances_on_appearance_type_id  (appearance_type_id)
#  index_appearances_on_recording_id        (recording_id)
#  index_appearances_on_talk_id             (talk_id)
#
# Foreign Keys
#
#  fk_rails_...  (appearance_type_id => appearance_types.id)
#  fk_rails_...  (recording_id => recordings.id)
#  fk_rails_...  (talk_id => talks.id)
#
require 'rails_helper'

RSpec.describe Appearance, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:appearance)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:appearance_type) }
    it { is_expected.to belong_to(:talk).optional }
    it { is_expected.to have_many(:recordings).dependent(:destroy) }
  end

  describe 'validations' do
    # it "is invalid without an event"
    it { is_expected.to validate_presence_of(:event) }
    # it "is invalid without a date"
    it { is_expected.to validate_presence_of(:date) }
    # it "is invalid without a location"
    it { is_expected.to validate_presence_of(:location) }
    # it "is invalid without noting who is appearing"
    it { is_expected.to validate_presence_of(:who) }
    # it "is invalid without noting what they're speaking about"
    it { is_expected.to validate_presence_of(:what) }
  end
end
