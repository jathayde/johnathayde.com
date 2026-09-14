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
require 'rails_helper'

RSpec.describe Studio::Post, type: :model do
  describe "defaults" do
    it "starts as a draft in the tracking category" do
      post = described_class.new
      expect(post).to be_draft
      expect(post).to be_tracking
    end

    it "sets published_at automatically when published without a date" do
      post = FactoryBot.create(:studio_post, status: "published", published_at: nil)
      expect(post.published_at).to be_present
      expect(post).to be_live
    end
  end

  describe ".live" do
    it "includes published posts with a past publish date and excludes drafts and scheduled posts" do
      live = FactoryBot.create(:studio_post, :published)
      draft = FactoryBot.create(:studio_post)
      scheduled = FactoryBot.create(:studio_post, :scheduled)
      expect(described_class.live).to contain_exactly(live)
      expect(described_class.live).not_to include(draft, scheduled)
    end
  end

  describe "slug" do
    it "is generated from the title when blank" do
      post = FactoryBot.create(:studio_post, title: "Tracking a Telecaster Through a Plate")
      expect(post.slug).to eq("tracking-a-telecaster-through-a-plate")
    end

    it "keeps a manually entered slug" do
      post = FactoryBot.create(:studio_post, title: "Long Title Here", slug: "Short One")
      expect(post.slug).to eq("short-one")
    end

    it "does not change when the title changes" do
      post = FactoryBot.create(:studio_post, title: "Original")
      post.update!(title: "Renamed")
      expect(post.slug).to eq("original")
    end

    it "rejects the reserved literal used by the gear route" do
      expect(FactoryBot.build(:studio_post, slug: "gear")).not_to be_valid
    end
  end

  describe "SEO fallbacks" do
    it "uses the title when meta_title is blank" do
      post = FactoryBot.build(:studio_post, title: "T", meta_title: "")
      expect(post.meta_title_or_title).to eq("T")
      post.meta_title = "Custom"
      expect(post.meta_title_or_title).to eq("Custom")
    end

    it "uses the summary, truncated to 160 characters, when meta_description is blank" do
      post = FactoryBot.build(:studio_post, summary: "x" * 300, meta_description: "")
      expect(post.meta_description_or_summary.length).to eq(160)
      post.meta_description = "Custom"
      expect(post.meta_description_or_summary).to eq("Custom")
    end

    it "caps meta_description at 160 characters" do
      expect(FactoryBot.build(:studio_post, meta_description: "x" * 161)).not_to be_valid
      expect(FactoryBot.build(:studio_post, meta_description: "x" * 160)).to be_valid
    end
  end

  describe "youtube_id" do
    it "accepts an 11-character id and rejects a full URL" do
      expect(FactoryBot.build(:studio_post, youtube_id: "dQw4w9WgXcQ")).to be_valid
      expect(FactoryBot.build(:studio_post, youtube_id: "https://youtu.be/dQw4w9WgXcQ")).not_to be_valid
    end

    it "derives embed, watch, and thumbnail URLs" do
      post = FactoryBot.build(:studio_post, :with_video)
      expect(post.youtube_embed_url).to eq("https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ")
      expect(post.youtube_watch_url).to eq("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
      expect(post.youtube_thumbnail_url).to eq("https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg")
    end
  end

  describe "canonical_url" do
    it "allows blank and http(s) URLs, rejects other schemes" do
      expect(FactoryBot.build(:studio_post, canonical_url: "")).to be_valid
      expect(FactoryBot.build(:studio_post, canonical_url: "https://example.com/p")).to be_valid
      expect(FactoryBot.build(:studio_post, canonical_url: "javascript:alert(1)")).not_to be_valid
    end
  end

  describe "gear items" do
    it "links to gear items both ways and refuses duplicates" do
      post = FactoryBot.create(:studio_post)
      item = FactoryBot.create(:studio_gear_item)
      post.gear_items << item
      expect(item.posts).to include(post)
      expect { post.post_gear_items.create!(gear_item: item) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "audio samples" do
    it "are ordered by position and destroyed with the post" do
      post = FactoryBot.create(:studio_post)
      second = FactoryBot.create(:studio_audio_sample, post: post, position: 2)
      first = FactoryBot.create(:studio_audio_sample, post: post, position: 1)
      expect(post.audio_samples).to eq([first, second])
      expect { post.destroy }.to change(Studio::AudioSample, :count).by(-2)
    end
  end
end
