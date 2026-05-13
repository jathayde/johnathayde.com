require 'rails_helper'

RSpec.describe "/admin/appearances/:appearance_id/recordings", type: :request do
  let(:appearance) { FactoryBot.create(:appearance) }
  let(:recording) { FactoryBot.create(:recording, appearance: appearance) }

  let(:valid_attributes) do
    { title: "Talk Video", url: "https://example.com/video" }
  end

  describe "GET new" do
    it "challenges unauthenticated requests" do
      get new_admin_appearance_recording_path(appearance)
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth" do
      get new_admin_appearance_recording_path(appearance), headers: admin_auth_headers
      expect(response).to be_successful
    end
  end

  describe "POST create" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_appearance_recordings_path(appearance), params: { recording: valid_attributes }
      }.not_to change(Recording, :count)
    end

    it "creates with admin auth" do
      expect {
        post admin_appearance_recordings_path(appearance),
             params: { recording: valid_attributes },
             headers: admin_auth_headers
      }.to change(Recording, :count).by(1)
    end
  end

  describe "DELETE destroy" do
    it "rejects unauthenticated requests" do
      recording
      expect {
        delete admin_appearance_recording_path(appearance, recording)
      }.not_to change(Recording, :count)
    end

    it "destroys with admin auth" do
      recording
      expect {
        delete admin_appearance_recording_path(appearance, recording), headers: admin_auth_headers
      }.to change(Recording, :count).by(-1)
    end
  end
end
