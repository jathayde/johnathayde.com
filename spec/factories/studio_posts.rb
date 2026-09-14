# == Schema Information
#
# Table name: studio_posts
#
#  id               :bigint           not null, primary key
#  canonical_url    :string
#  category         :string           default("tracking"), not null
#  meta_description :string(160)
#  meta_title       :string
#  og_image         :string
#  published_at     :datetime
#  signal_chain     :text
#  slug             :string
#  status           :string           default("draft"), not null
#  summary          :string           not null
#  title            :string           not null
#  verdict          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  youtube_id       :string
#
# Indexes
#
#  index_studio_posts_on_published_at  (published_at)
#  index_studio_posts_on_slug          (slug) UNIQUE
#  index_studio_posts_on_status        (status)
#
FactoryBot.define do
  factory :studio_post, class: "Studio::Post" do
    sequence(:title) { |n| "Studio Post #{n}" }
    summary  { "A short summary of the session, long enough to stand in for a meta description in tests." }
    body     { "<p>#{Faker::Lorem.paragraph}</p>" }
    category { "tracking" }
    status   { "draft" }

    trait :published do
      status       { "published" }
      published_at { 1.day.ago }
    end

    trait :scheduled do
      status       { "published" }
      published_at { 1.week.from_now }
    end

    trait :with_video do
      youtube_id { "dQw4w9WgXcQ" }
    end
  end
end
