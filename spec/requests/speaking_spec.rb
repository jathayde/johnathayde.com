require 'rails_helper'

RSpec.describe "Speakings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/speaking"
      expect(response).to have_http_status(:success)
    end
  end

end
