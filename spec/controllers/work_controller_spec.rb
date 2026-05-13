require 'rails_helper'

RSpec.describe WorkController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #livingsocial_csr" do
    it "returns http success" do
      get :livingsocial_csr
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #navanti_pulse" do
    it "returns http success" do
      get :navanti_pulse
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
