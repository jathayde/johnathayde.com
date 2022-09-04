# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  describe 'GET Contact Form' do
    it 'returns http success' do
      get '/contact'
      expect(response).to have_http_status(:success)
    end
  end
end
