# == Schema Information
#
# Table name: articles
#
#  id                  :bigint           not null, primary key
#  author              :string
#  body                :text             not null
#  hidden_on_index     :boolean          default(FALSE)
#  img_source          :string
#  meta_description    :string(155)      not null
#  og_description      :string
#  og_image            :string
#  og_title            :string
#  page_title          :text             not null
#  published_at        :datetime
#  slug                :string
#  status              :string           default("draft"), not null
#  subtitle            :string
#  title               :string           not null
#  twitter_description :string
#  twitter_image       :string
#  twitter_title       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "status" do
    it "defaults to draft" do
      expect(Article.new).to be_draft
    end

    it "sets published_at automatically when published without a date" do
      article = FactoryBot.create(:article, status: "published", published_at: nil)
      expect(article.published_at).to be_present
      expect(article).to be_live
    end
  end

  describe ".live" do
    it "includes published articles with a past publish date" do
      article = FactoryBot.create(:article, :published)
      expect(Article.live).to include(article)
    end

    it "excludes drafts" do
      draft = FactoryBot.create(:article)
      expect(Article.live).not_to include(draft)
    end

    it "excludes scheduled articles" do
      scheduled = FactoryBot.create(:article, :scheduled)
      expect(Article.live).not_to include(scheduled)
    end
  end

  describe ".visible_on_index" do
    it "excludes live articles hidden from the index" do
      hidden = FactoryBot.create(:article, :published, hidden_on_index: true)
      visible = FactoryBot.create(:article, :published)
      expect(Article.visible_on_index).to contain_exactly(visible)
      expect(Article.live).to include(hidden)
    end
  end

  describe "canonical_url" do
    it "allows blank" do
      expect(FactoryBot.build(:article, canonical_url: "")).to be_valid
    end

    it "allows http(s) URLs" do
      expect(FactoryBot.build(:article, canonical_url: "https://meticulous.com/post")).to be_valid
    end

    it "rejects non-http schemes" do
      expect(FactoryBot.build(:article, canonical_url: "javascript:alert(1)")).not_to be_valid
    end
  end

  describe "#live? / #scheduled?" do
    it "is live when published in the past" do
      article = FactoryBot.build(:article, :published)
      expect(article).to be_live
      expect(article).not_to be_scheduled
    end

    it "is scheduled when published with a future date" do
      article = FactoryBot.build(:article, :scheduled)
      expect(article).to be_scheduled
      expect(article).not_to be_live
    end

    it "is neither when draft" do
      article = FactoryBot.build(:article)
      expect(article).not_to be_live
      expect(article).not_to be_scheduled
    end
  end
end
