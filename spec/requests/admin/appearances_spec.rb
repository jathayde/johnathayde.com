require 'rails_helper'

RSpec.describe "/admin/appearances", type: :request do
  let(:appearance) { FactoryBot.create(:appearance) }
  let(:appearance_type) { FactoryBot.create(:appearance_type) }

  let(:valid_attributes) do
    {
      event: 'RailsConf 2025',
      date: Date.new(2025, 5, 15),
      location: 'Philadelphia, PA',
      who: 'John Athayde',
      what: 'A Talk About Upgrades',
      appearance_type_id: appearance_type.id
    }
  end

  let(:invalid_attributes) do
    { event: '', date: nil, location: '', who: '', what: '' }
  end

  describe 'GET /admin/appearances' do
    it 'challenges unauthenticated requests' do
      get admin_appearances_path
      expect(response).to have_http_status(:unauthorized)
    end

    it 'renders with admin auth' do
      appearance
      get admin_appearances_path, headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/appearances/:id' do
    it 'renders with admin auth' do
      get admin_appearance_path(appearance), headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/appearances/new' do
    it 'challenges unauthenticated requests' do
      get new_admin_appearance_path
      expect(response).to have_http_status(:unauthorized)
    end

    it 'renders with admin auth' do
      get new_admin_appearance_path, headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe 'POST /admin/appearances' do
    it 'rejects unauthenticated requests' do
      expect {
        post admin_appearances_path, params: { appearance: valid_attributes }
      }.not_to change(Appearance, :count)
    end

    context 'with admin auth' do
      it 'creates an appearance with valid params' do
        expect {
          post admin_appearances_path, params: { appearance: valid_attributes }, headers: admin_auth_headers
        }.to change(Appearance, :count).by(1)
      end

      it 'redirects to the admin show page after create' do
        post admin_appearances_path, params: { appearance: valid_attributes }, headers: admin_auth_headers
        expect(response).to redirect_to(admin_appearance_url(Appearance.last))
      end

      it 'returns unprocessable_content for invalid params' do
        post admin_appearances_path, params: { appearance: invalid_attributes }, headers: admin_auth_headers
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH /admin/appearances/:id' do
    it 'rejects unauthenticated requests' do
      patch admin_appearance_path(appearance), params: { appearance: { event: "Hijack" } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'updates with admin auth' do
      patch admin_appearance_path(appearance),
            params: { appearance: valid_attributes.merge(event: 'Updated Event') },
            headers: admin_auth_headers
      expect(appearance.reload.event).to eq('Updated Event')
    end
  end

  describe 'DELETE /admin/appearances/:id' do
    it 'rejects unauthenticated requests' do
      appearance
      expect {
        delete admin_appearance_path(appearance)
      }.not_to change(Appearance, :count)
    end

    it 'destroys with admin auth' do
      appearance
      expect {
        delete admin_appearance_path(appearance), headers: admin_auth_headers
      }.to change(Appearance, :count).by(-1)
    end
  end
end
