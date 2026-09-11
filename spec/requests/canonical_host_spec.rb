# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Canonical host and sitemap', type: :request do
  describe 'bare domain' do
    it '301s to www preserving the path and query' do
      get '/blog?page=2', headers: { 'Host' => 'johnathayde.com' }
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to('https://www.johnathayde.com/blog?page=2')
    end
  end

  describe 'www domain' do
    it 'serves the page directly' do
      get '/resume', headers: { 'Host' => 'www.johnathayde.com' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /sitemap.xml' do
    it '301s to the S3-hosted sitemap' do
      get '/sitemap.xml'
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to('https://johnathayde-com.s3.amazonaws.com/sitemaps/sitemap.xml.gz')
    end
  end
end
