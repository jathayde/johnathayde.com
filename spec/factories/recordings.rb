FactoryBot.define do
  factory :recording do
    title { "Test Talk Is here" }
    url { "http://www.youtube.com/testvideo.mp4" }
    slug { "test-talk-is-here" }
    recorded_on { "2021-09-05" }
    notes { "MyText" }
    association :appearance
  end
end
