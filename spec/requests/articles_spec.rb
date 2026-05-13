require 'rails_helper'

RSpec.describe "/articles (public)", type: :request do
  let(:published_article) { FactoryBot.create(:article, published_at: 1.day.ago) }
  let(:draft_article) { FactoryBot.create(:article, published_at: nil) }

  describe "GET /articles" do
    it "lists only published articles" do
      published_article
      draft_article
      get articles_path
      expect(response).to be_successful
      expect(response.body).to include(published_article.title)
      expect(response.body).not_to include(draft_article.title)
    end
  end

  describe "GET /articles/:id" do
    it "shows a published article" do
      get article_path(published_article)
      expect(response).to be_successful
    end

    it "404s on a draft" do
      get article_path(draft_article)
      expect(response).to have_http_status(:not_found)
    end
  end
end
