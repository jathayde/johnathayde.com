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
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:who) }
    it { is_expected.to validate_presence_of(:what) }
  end

  describe 'scopes' do
    let!(:past_appearance) do
      FactoryBot.create(:appearance, event: 'Past Talk', date: 2.weeks.ago.to_date)
    end
    let!(:future_appearance) do
      FactoryBot.create(:appearance, event: 'Future Talk', date: 2.weeks.from_now.to_date)
    end
    let!(:today_appearance) do
      FactoryBot.create(:appearance, event: 'Today Talk', date: Time.zone.today)
    end

    describe '.upcoming' do
      it 'includes appearances on or after today' do
        expect(Appearance.upcoming).to include(today_appearance, future_appearance)
      end

      it 'excludes past appearances' do
        expect(Appearance.upcoming).not_to include(past_appearance)
      end
    end

    describe '.past' do
      it 'includes appearances before today' do
        expect(Appearance.past).to include(past_appearance)
      end

      it 'excludes today and future appearances' do
        expect(Appearance.past).not_to include(today_appearance, future_appearance)
      end
    end
  end

  describe 'date helpers' do
    let(:appearance) { FactoryBot.build(:appearance, date: Date.new(2024, 3, 15)) }

    it '#year returns the 4-digit year' do
      expect(appearance.year).to eq('2024')
    end

    it '#month returns the zero-padded month' do
      expect(appearance.month).to eq('03')
    end
  end

  describe 'slug generation' do
    it 'parameterizes the event into the slug on save' do
      appearance = FactoryBot.create(:appearance, event: 'RailsConf 2025 — Special Edition')
      expect(appearance.slug).to eq('railsconf-2025-special-edition')
    end

    it 'regenerates the slug when the event changes' do
      appearance = FactoryBot.create(:appearance, event: 'Original Event')
      expect(appearance.slug).to eq('original-event')

      appearance.update!(event: 'Renamed Event')
      expect(appearance.slug).to eq('renamed-event')
    end
  end
end
