require 'rails_helper'

RSpec.describe "/admin/studio/gear_items", type: :request do
  let(:gear_item) { FactoryBot.create(:studio_gear_item) }

  let(:valid_attributes) do
    { name: "U 87 Ai", manufacturer: "Neumann", category: "mics", quantity: 2, blurb: "The one.", affiliate_url: "https://example.com/u87" }
  end

  describe "GET /admin/studio/gear_items" do
    it "challenges unauthenticated requests" do
      get admin_studio_gear_items_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders grouped, sortable lists with admin auth" do
      gear_item
      get admin_studio_gear_items_path, headers: admin_auth_headers
      expect(response).to be_successful
      expect(response.body).to include(gear_item.display_name)
      expect(response.body).to include('data-controller="sortable"')
    end
  end

  describe "POST /admin/studio/gear_items" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_studio_gear_items_path, params: { studio_gear_item: valid_attributes }
      }.not_to change(Studio::GearItem, :count)
    end

    it "creates with admin auth and appends to the category" do
      FactoryBot.create(:studio_gear_item, category: "mics", position: 4)
      expect {
        post admin_studio_gear_items_path, params: { studio_gear_item: valid_attributes }, headers: admin_auth_headers
      }.to change(Studio::GearItem, :count).by(1)
      expect(Studio::GearItem.last.position).to eq(5)
      expect(Studio::GearItem.last.quantity).to eq(2)
    end
  end

  describe "PATCH /admin/studio/gear_items/:id" do
    it "updates with admin auth" do
      patch admin_studio_gear_item_path(gear_item), params: { studio_gear_item: { active: "0", blurb: "Retired" } },
                                                    headers: admin_auth_headers
      expect(gear_item.reload.active).to be(false)
      expect(gear_item.blurb).to eq("Retired")
    end
  end

  describe "PATCH /admin/studio/gear_items/reorder" do
    it "rewrites positions from the posted id order" do
      a = FactoryBot.create(:studio_gear_item, position: 0)
      b = FactoryBot.create(:studio_gear_item, position: 1)
      patch reorder_admin_studio_gear_items_path, params: { ids: [b.id, a.id] }, headers: admin_auth_headers, as: :json
      expect(response).to have_http_status(:no_content)
      expect([a.reload.position, b.reload.position]).to eq([1, 0])
    end
  end

  describe "DELETE /admin/studio/gear_items/:id" do
    it "destroys with admin auth and unlinks it from posts" do
      post_record = FactoryBot.create(:studio_post)
      post_record.gear_items << gear_item
      expect {
        delete admin_studio_gear_item_path(gear_item), headers: admin_auth_headers
      }.to change(Studio::GearItem, :count).by(-1)
      expect(post_record.reload.gear_items).to be_empty
    end
  end
end
