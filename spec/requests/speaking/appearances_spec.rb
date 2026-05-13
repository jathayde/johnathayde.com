require 'rails_helper'

RSpec.describe "/speaking/appearances", type: :request do
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

  describe 'GET /speaking/appearances' do
    it 'renders a successful response' do
      appearance # touch
      get speaking_appearances_url
      expect(response).to be_successful
    end
  end

  describe 'GET /speaking/appearances/:id' do
    it 'renders a successful response' do
      get speaking_appearance_url(appearance)
      expect(response).to be_successful
    end
  end

  describe 'GET /speaking/appearances/new' do
    it 'renders a successful response' do
      get new_speaking_appearance_url
      expect(response).to be_successful
    end
  end

  describe 'GET /speaking/appearances/:id/edit' do
    it 'renders a successful response' do
      get edit_speaking_appearance_url(appearance)
      expect(response).to be_successful
    end
  end

  describe 'POST /speaking/appearances' do
    context 'with valid parameters' do
      it 'creates a new Appearance' do
        expect {
          post speaking_appearances_url, params: { speaking_appearance: valid_attributes }
        }.to change(Appearance, :count).by(1)
      end

      it 'redirects to the created appearance' do
        post speaking_appearances_url, params: { speaking_appearance: valid_attributes }
        expect(response).to redirect_to(speaking_appearance_url(Appearance.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Appearance' do
        expect {
          post speaking_appearances_url, params: { speaking_appearance: invalid_attributes }
        }.not_to change(Appearance, :count)
      end

      it 'returns unprocessable_entity' do
        post speaking_appearances_url, params: { speaking_appearance: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH /speaking/appearances/:id' do
    context 'with valid parameters' do
      it 'updates the requested appearance' do
        patch speaking_appearance_url(appearance),
          params: { speaking_appearance: valid_attributes.merge(event: 'Updated Event') }
        appearance.reload
        expect(appearance.event).to eq('Updated Event')
      end

      it 'redirects to the appearance' do
        patch speaking_appearance_url(appearance),
          params: { speaking_appearance: valid_attributes }
        # Slug is regenerated from event by before_validation, so reload
        # to pick up the new slug for the URL match
        expect(response).to redirect_to(speaking_appearance_url(appearance.reload))
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable_entity' do
        patch speaking_appearance_url(appearance),
          params: { speaking_appearance: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /speaking/appearances/:id' do
    it 'destroys the requested appearance' do
      appearance # touch
      expect {
        delete speaking_appearance_url(appearance)
      }.to change(Appearance, :count).by(-1)
    end

    it 'redirects to the appearances list' do
      delete speaking_appearance_url(appearance)
      expect(response).to redirect_to(speaking_appearances_url)
    end
  end
end
