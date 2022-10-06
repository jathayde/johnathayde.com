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
FactoryBot.define do
  factory :recording do
    title { 'Test Talk Is here' }
    url { 'http://www.youtube.com/testvideo.mp4' }
    slug { 'test-talk-is-here' }
    recorded_on { '2021-09-05' }
    notes { 'MyText' }
    association :appearance
  end
end
