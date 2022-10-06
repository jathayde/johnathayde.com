# frozen_string_literal: true

# == Schema Information
#
# Table name: recordings
#
#  id            :bigint           not null, primary key
#  embed_code    :text
#  embed_host    :string
#  embedded      :boolean          default(FALSE)
#  notes         :text
#  recorded_on   :date
#  slug          :string
#  title         :string           not null
#  url           :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  appearance_id :bigint           not null
#  talk_id       :bigint
#
# Indexes
#
#  index_recordings_on_appearance_id  (appearance_id)
#  index_recordings_on_talk_id        (talk_id)
#
# Foreign Keys
#
#  fk_rails_...  (appearance_id => appearances.id)
#  fk_rails_...  (talk_id => talks.id)
#
require 'rails_helper'

RSpec.describe Recording, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:recording)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:talk).optional }
    it { is_expected.to belong_to(:appearance) }
  end

  describe 'validations' do
    # it "is invalid without a title"
    it { is_expected.to validate_presence_of(:title) }

    # it "is invalid without a url"
    it { is_expected.to validate_presence_of(:url) }

    it 'is invalid if the URL is not formatted properly'
  end
end
