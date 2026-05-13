require 'rails_helper'

RSpec.describe "/admin/talks", type: :request do
  let(:talk) { FactoryBot.create(:talk) }

  let(:valid_attributes) do
    { title: "RailsConf Keynote", description: "About upgrading Rails." }
  end

  let(:invalid_attributes) do
    { title: "", description: "" }
  end

  describe "GET /admin/talks" do
    it "challenges unauthenticated requests" do
      get admin_talks_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth" do
      talk
      get admin_talks_path, headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe "GET /admin/talks/new" do
    it "challenges unauthenticated requests" do
      get new_admin_talk_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth" do
      get new_admin_talk_path, headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe "POST /admin/talks" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_talks_path, params: { talk: valid_attributes }
      }.not_to change(Talk, :count)
    end

    context "with admin auth" do
      it "creates a talk with valid params" do
        expect {
          post admin_talks_path, params: { talk: valid_attributes }, headers: admin_auth_headers
        }.to change(Talk, :count).by(1)
      end

      it "redirects to the admin show page after create" do
        post admin_talks_path, params: { talk: valid_attributes }, headers: admin_auth_headers
        expect(response).to redirect_to(admin_talk_url(Talk.last))
      end

      it "rejects invalid params" do
        post admin_talks_path, params: { talk: invalid_attributes }, headers: admin_auth_headers
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /admin/talks/:id" do
    it "rejects unauthenticated requests" do
      patch admin_talk_path(talk), params: { talk: { title: "Hijack" } }
      expect(response).to have_http_status(:unauthorized)
    end

    it "updates with admin auth" do
      patch admin_talk_path(talk), params: { talk: { title: "Updated Title" } }, headers: admin_auth_headers
      expect(talk.reload.title).to eq("Updated Title")
    end
  end

  describe "DELETE /admin/talks/:id" do
    it "rejects unauthenticated requests" do
      talk
      expect {
        delete admin_talk_path(talk)
      }.not_to change(Talk, :count)
    end

    it "destroys with admin auth" do
      talk
      expect {
        delete admin_talk_path(talk), headers: admin_auth_headers
      }.to change(Talk, :count).by(-1)
    end
  end
end
