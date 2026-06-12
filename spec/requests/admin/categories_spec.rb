require 'rails_helper'

RSpec.describe "/admin/categories", type: :request do
  let(:category) { FactoryBot.create(:category) }

  let(:valid_attributes) { { name: "Design Systems", description: "Posts about design systems." } }

  describe "GET /admin/categories" do
    it "challenges unauthenticated requests" do
      get admin_categories_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth" do
      category
      get admin_categories_path, headers: admin_auth_headers
      expect(response).to be_successful
      expect(response.body).to include(category.name)
    end
  end

  describe "POST /admin/categories" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_categories_path, params: { category: valid_attributes }
      }.not_to change(Category, :count)
    end

    it "creates with admin auth" do
      expect {
        post admin_categories_path, params: { category: valid_attributes }, headers: admin_auth_headers
      }.to change(Category, :count).by(1)
    end
  end

  describe "PATCH /admin/categories/:id" do
    it "updates with admin auth" do
      patch admin_category_path(category), params: { category: { name: "Renamed" } }, headers: admin_auth_headers
      expect(category.reload.name).to eq("Renamed")
    end
  end

  describe "DELETE /admin/categories/:id" do
    it "destroys an unused category" do
      category
      expect {
        delete admin_category_path(category), headers: admin_auth_headers
      }.to change(Category, :count).by(-1)
    end

    it "refuses to destroy a category in use" do
      FactoryBot.create(:article, category: category)
      expect {
        delete admin_category_path(category), headers: admin_auth_headers
      }.not_to change(Category, :count)
    end
  end
end
