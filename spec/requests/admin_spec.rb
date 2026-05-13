require 'rails_helper'

RSpec.describe "/admin", type: :request do
  describe "GET /admin" do
    it "challenges unauthenticated requests with 401" do
      get admin_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders the dashboard with valid basic auth" do
      get admin_path, headers: admin_auth_headers
      expect(response).to be_successful
    end

    it "401s with wrong credentials" do
      get admin_path, headers: {
        "HTTP_AUTHORIZATION" =>
          ActionController::HttpAuthentication::Basic.encode_credentials("wrong", "wrong")
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
