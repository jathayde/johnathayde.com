require 'rails_helper'

RSpec.describe "/blog (public)", type: :request do
  let(:published_article) { FactoryBot.create(:article, :published) }
  let(:draft_article) { FactoryBot.create(:article) }
  let(:scheduled_article) { FactoryBot.create(:article, :scheduled) }

  describe "GET /blog" do
    it "lists only live articles" do
      published_article
      draft_article
      scheduled_article
      get blog_path
      expect(response).to be_successful
      expect(response.body).to include(published_article.title)
      expect(response.body).not_to include(draft_article.title)
      expect(response.body).not_to include(scheduled_article.title)
    end
  end

  describe "GET /blog/:slug" do
    it "shows a published article" do
      get blog_post_path(published_article)
      expect(response).to be_successful
    end

    it "404s on a draft" do
      get blog_post_path(draft_article)
      expect(response).to have_http_status(:not_found)
    end

    it "404s on a scheduled article until its publish time" do
      get blog_post_path(scheduled_article)
      expect(response).to have_http_status(:not_found)
    end

    it "shows a draft to an authenticated admin (preview)" do
      get blog_post_path(draft_article), headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe "canonical URL and structured data" do
    it "defaults rel=canonical to the post's own /blog URL" do
      get blog_post_path(published_article)
      expect(response.body).to include(%(rel="canonical" href="http://www.example.com/blog/#{published_article.slug}"))
    end

    it "points rel=canonical at the original publication when cross-posted" do
      article = FactoryBot.create(:article, :published, canonical_url: "https://meticulous.com/some-post")
      get blog_post_path(article)
      expect(response.body).to include(%(rel="canonical" href="https://meticulous.com/some-post"))
      expect(response.body).to include("Originally published at")
      expect(response.body).to include("meticulous.com")
    end

    it "embeds BlogPosting JSON-LD" do
      get blog_post_path(published_article)
      expect(response.body).to include('<script type="application/ld+json">')
      expect(response.body).to include('"@type":"BlogPosting"')
      expect(response.body).to include(%("headline":"#{published_article.title}"))
    end
  end

  describe "feature image" do
    it "renders the hero image and og:image when attached" do
      published_article.feature_image.attach(
        io: Rails.root.join("spec/fixtures/files/feature.png").open,
        filename: "feature.png", content_type: "image/png"
      )
      get blog_post_path(published_article)
      expect(response.body).to include('class="feature-image"')
      expect(response.body).to match(/property="og:image" content="http/)
    end

    it "renders no figure when absent" do
      get blog_post_path(published_article)
      expect(response.body).not_to include('figure class="feature-image"')
    end
  end

  describe "GET /blog/category/:slug" do
    let(:category) { FactoryBot.create(:category, name: "Process") }

    it "lists live articles in the category" do
      in_category = FactoryBot.create(:article, :published, category: category)
      other = FactoryBot.create(:article, :published)
      draft_in_category = FactoryBot.create(:article, category: category)

      get blog_category_path(category)
      expect(response).to be_successful
      expect(response.body).to include(in_category.title)
      expect(response.body).not_to include(other.title)
      expect(response.body).not_to include(draft_in_category.title)
    end

    it "404s on an unknown category" do
      get blog_category_path("nope")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /blog/tag/:tag" do
    it "lists live articles with the tag" do
      tagged = FactoryBot.create(:article, :published, tag_list: "rails")
      untagged = FactoryBot.create(:article, :published)
      draft_tagged = FactoryBot.create(:article, tag_list: "rails")

      get blog_tag_path("rails")
      expect(response).to be_successful
      expect(response.body).to include(tagged.title)
      expect(response.body).not_to include(untagged.title)
      expect(response.body).not_to include(draft_tagged.title)
    end

    it "404s on an unknown tag" do
      get blog_tag_path("nope")
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /blog/feed" do
    it "returns an Atom feed of live posts only" do
      published_article
      draft_article
      scheduled_article

      get blog_feed_path(format: :atom)
      expect(response).to be_successful
      expect(response.media_type).to eq("application/atom+xml")
      expect(response.body).to include("<feed")
      expect(response.body).to include(published_article.title)
      expect(response.body).not_to include(draft_article.title)
      expect(response.body).not_to include(scheduled_article.title)
    end

    it "advertises the feed on public pages" do
      get blog_path
      expect(response.body).to include('type="application/atom+xml"')
    end
  end

  describe "machine-readable formats" do
    it "serves the post as Markdown with front matter at .md" do
      article = FactoryBot.create(:article, :published, tag_list: "rails", canonical_url: "https://meticulous.com/x")
      get blog_post_path(article, format: :md)
      expect(response).to be_successful
      expect(response.media_type).to eq("text/markdown")
      expect(response.body).to include("title: #{article.title}")
      expect(response.body).to include("canonical_url: https://meticulous.com/x")
      expect(response.body).to include("---")
    end

    it "serves the post as JSON at .json" do
      get blog_post_path(published_article, format: :json)
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["title"]).to eq(published_article.title)
      expect(json["slug"]).to eq(published_article.slug)
      expect(json["body_markdown"]).to be_present
      expect(json["markdown_url"]).to end_with(".md")
    end

    it "404s machine formats for drafts" do
      get blog_post_path(draft_article, format: :md)
      expect(response).to have_http_status(:not_found)
    end

    it "serves /llms.txt listing live posts with .md links" do
      published_article
      draft_article
      get "/llms.txt"
      expect(response).to be_successful
      expect(response.media_type).to eq("text/plain")
      expect(response.body).to include(published_article.title)
      expect(response.body).to include("/blog/#{published_article.slug}.md")
      expect(response.body).not_to include(draft_article.title)
    end
  end

  describe "legacy /articles URLs" do
    it "301s the index to /blog" do
      get "/articles"
      expect(response).to redirect_to("/blog")
      expect(response).to have_http_status(:moved_permanently)
    end

    it "301s a post to its /blog URL" do
      get "/articles/#{published_article.slug}"
      expect(response).to redirect_to("/blog/#{published_article.slug}")
      expect(response).to have_http_status(:moved_permanently)
    end
  end
end
