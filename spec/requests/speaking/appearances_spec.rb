require 'rails_helper'

RSpec.describe "/speaking/appearances (public)", type: :request do
  let(:appearance) { FactoryBot.create(:appearance) }

  describe 'GET /speaking/appearances' do
    it 'renders to anonymous visitors' do
      appearance
      get speaking_appearances_path
      expect(response).to be_successful
    end
  end

  describe 'GET /speaking/appearances/:id' do
    it 'renders to anonymous visitors' do
      get speaking_appearance_path(appearance)
      expect(response).to be_successful
    end
  end

  it 'has no public POST/PATCH/DELETE routes (admin-only via /admin/appearances)' do
    expect(Rails.application.routes.url_helpers).not_to respond_to(:new_speaking_appearance_path)
    expect(Rails.application.routes.url_helpers).not_to respond_to(:edit_speaking_appearance_path)
  end
end
