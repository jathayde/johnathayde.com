require 'rails_helper'

RSpec.describe "/admin/appearance_types", type: :request do
  let(:appearance_type) { FactoryBot.create(:appearance_type) }

  describe "GET index" do
    it "challenges unauthenticated requests" do
      get admin_appearance_types_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth" do
      get admin_appearance_types_path, headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe "POST create" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_appearance_types_path, params: { appearance_type: { title: "Webinar" } }
      }.not_to change(AppearanceType, :count)
    end

    it "creates with admin auth" do
      expect {
        post admin_appearance_types_path,
             params: { appearance_type: { title: "Webinar" } },
             headers: admin_auth_headers
      }.to change(AppearanceType, :count).by(1)
    end
  end

  describe "DELETE destroy" do
    it "blocks deletion when appearances reference the type" do
      FactoryBot.create(:appearance, appearance_type: appearance_type)
      expect {
        delete admin_appearance_type_path(appearance_type), headers: admin_auth_headers
      }.not_to change(AppearanceType, :count)
      expect(flash[:alert]).to include("Cannot delete")
    end

    it "destroys when no appearances use it" do
      appearance_type # ensure exists
      expect {
        delete admin_appearance_type_path(appearance_type), headers: admin_auth_headers
      }.to change(AppearanceType, :count).by(-1)
    end
  end
end
