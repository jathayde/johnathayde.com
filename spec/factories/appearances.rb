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
FactoryBot.define do
  factory :appearance do
    event { 'MyString' }
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    location { 'MyString' }
    who { 'MyString' }
    what { 'MyString' }
    notes { Faker::Lorem.paragraph }
    url { 'MyString' }
    slug { 'MyString' }
    association :appearance_type
  end
end
