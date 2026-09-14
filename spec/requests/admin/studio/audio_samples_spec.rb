require 'rails_helper'

RSpec.describe "/admin/studio/audio_samples", type: :request do
  let(:post_record) { FactoryBot.create(:studio_post) }
  let(:sample) { FactoryBot.create(:studio_audio_sample, post: post_record) }
  let(:upload) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/sample.wav"), "audio/wav") }

  describe "GET /admin/studio/posts/:post_id/audio_samples/new" do
    it "challenges unauthenticated requests" do
      get new_admin_studio_post_audio_sample_path(post_record)
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth" do
      get new_admin_studio_post_audio_sample_path(post_record), headers: admin_auth_headers
      expect(response).to be_successful
      expect(response.body).to include('accept="audio/*"')
    end
  end

  describe "POST /admin/studio/posts/:post_id/audio_samples" do
    it "creates with an audio upload" do
      expect {
        post admin_studio_post_audio_samples_path(post_record),
             params: { studio_audio_sample: { label: "dry", position: 0, file: upload } },
             headers: admin_auth_headers
      }.to change(Studio::AudioSample, :count).by(1)
      expect(response).to redirect_to(admin_studio_post_path(post_record))
      expect(Studio::AudioSample.last.file).to be_attached
    end

    it "rejects a non-audio upload" do
      image = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/feature.png"), "image/png")
      expect {
        post admin_studio_post_audio_samples_path(post_record),
             params: { studio_audio_sample: { label: "dry", file: image } },
             headers: admin_auth_headers
      }.not_to change(Studio::AudioSample, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /admin/studio/audio_samples/:id" do
    it "updates the label without requiring a new file" do
      patch admin_studio_audio_sample_path(sample), params: { studio_audio_sample: { label: "wet — plate" } },
                                                    headers: admin_auth_headers
      expect(sample.reload.label).to eq("wet — plate")
      expect(sample.file).to be_attached
    end
  end

  describe "DELETE /admin/studio/audio_samples/:id" do
    it "destroys with admin auth" do
      sample
      expect {
        delete admin_studio_audio_sample_path(sample), headers: admin_auth_headers
      }.to change(Studio::AudioSample, :count).by(-1)
      expect(response).to redirect_to(admin_studio_post_path(post_record))
    end
  end
end
