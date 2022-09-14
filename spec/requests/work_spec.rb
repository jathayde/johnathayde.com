require 'rails_helper'

RSpec.describe "Works", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/work/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /livingsocial-csr" do
    it "returns http success" do
      get "/work/livingsocial-csr"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /navanti-pulse" do
    it "returns http success" do
      get "/work/navanti-pulse"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /procore" do
    it "returns http success" do
      get "/work/procore"
      expect(response).to have_http_status(:success)
    end
  end

end
