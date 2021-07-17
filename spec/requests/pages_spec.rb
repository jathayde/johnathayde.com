require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET root index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /resume" do
    it "returns http success" do
      get "/resume"
      expect(response).to have_http_status(:success)
    end
  end
end
