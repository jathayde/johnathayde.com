require 'rails_helper'

RSpec.describe "/admin/articles", type: :request do
  let(:article) { FactoryBot.create(:article, published_at: 1.day.ago) }
  let(:draft) { FactoryBot.create(:article, published_at: nil) }

  let(:valid_attributes) do
    {
      title: "Why we upgraded Rails",
      body: "It was time.",
      page_title: "Why we upgraded Rails",
      meta_description: "An article about Rails upgrades."
    }
  end

  describe "GET /admin/articles" do
    it "challenges unauthenticated requests" do
      get admin_articles_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth (includes drafts)" do
      article
      draft
      get admin_articles_path, headers: admin_auth_headers
      expect(response).to be_successful
      expect(response.body).to include(article.title)
      expect(response.body).to include(draft.title)
    end
  end

  describe "GET /admin/articles/:id" do
    it "shows a draft with admin auth (preview)" do
      get admin_article_path(draft), headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe "POST /admin/articles" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_articles_path, params: { article: valid_attributes }
      }.not_to change(Article, :count)
    end

    it "creates with admin auth" do
      expect {
        post admin_articles_path, params: { article: valid_attributes }, headers: admin_auth_headers
      }.to change(Article, :count).by(1)
    end
  end

  describe "DELETE /admin/articles/:id" do
    it "destroys with admin auth" do
      article
      expect {
        delete admin_article_path(article), headers: admin_auth_headers
      }.to change(Article, :count).by(-1)
    end
  end
end
