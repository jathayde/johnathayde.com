require 'rails_helper'

RSpec.describe WorkController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #livingsocial-csr" do
    it "returns http success" do
      get :livingsocial-csr
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #navanti-pulse" do
    it "returns http success" do
      get :navanti-pulse
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #procore" do
    it "returns http success" do
      get :procore
      expect(response).to have_http_status(:success)
    end
  end

end
