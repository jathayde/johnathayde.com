require 'rails_helper'

RSpec.describe "/admin/studio/posts", type: :request do
  let(:post_record) { FactoryBot.create(:studio_post, :published) }
  let(:draft) { FactoryBot.create(:studio_post) }

  let(:valid_attributes) do
    {
      title: "Tracking a Tele through a plate",
      summary: "Dry versus plate on a Telecaster.",
      body: "<p>Notes.</p>",
      category: "tracking"
    }
  end

  describe "GET /admin/studio/posts" do
    it "challenges unauthenticated requests" do
      get admin_studio_posts_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "renders with admin auth (includes drafts)" do
      post_record
      draft
      get admin_studio_posts_path, headers: admin_auth_headers
      expect(response).to be_successful
      expect(response.body).to include(post_record.title)
      expect(response.body).to include(draft.title)
    end
  end

  describe "GET /admin/studio/posts/new" do
    it "renders the editor and the SEO fields with counters and slug warning hooks" do
      get new_admin_studio_post_path, headers: admin_auth_headers
      expect(response).to be_successful
      expect(response.body).to include("<lexxy-editor")
      expect(response.body).to include('name="studio_post[slug]"')
      expect(response.body).to include('name="studio_post[meta_title]"')
      expect(response.body).to include('name="studio_post[meta_description]"')
      expect(response.body).to include('name="studio_post[og_image]"')
      expect(response.body).to include('name="studio_post[canonical_url]"')
      expect(response.body).to include('name="studio_post[published_at]"')
      expect(response.body).to include('data-controller="char-count"')
      expect(response.body).to include('data-controller="slug-warning"')
    end

    it "arms the slug warning only for a published post" do
      get edit_admin_studio_post_path(post_record), headers: admin_auth_headers
      expect(response.body).to include('data-slug-warning-published-value="true"')
      get edit_admin_studio_post_path(draft), headers: admin_auth_headers
      expect(response.body).to include('data-slug-warning-published-value="false"')
    end
  end

  describe "POST /admin/studio/posts" do
    it "rejects unauthenticated requests" do
      expect {
        post admin_studio_posts_path, params: { studio_post: valid_attributes }
      }.not_to change(Studio::Post, :count)
    end

    it "creates with admin auth, generating the slug and linking gear" do
      item = FactoryBot.create(:studio_gear_item)
      expect {
        post admin_studio_posts_path,
             params: { studio_post: valid_attributes.merge(gear_item_ids: [item.id]) },
             headers: admin_auth_headers
      }.to change(Studio::Post, :count).by(1)
      created = Studio::Post.last
      expect(created.slug).to eq("tracking-a-tele-through-a-plate")
      expect(created.gear_items).to eq([item])
    end

    it "re-renders the form on validation errors" do
      post admin_studio_posts_path, params: { studio_post: valid_attributes.merge(title: "") },
                                    headers: admin_auth_headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /admin/studio/posts/:id" do
    it "updates with admin auth and honours a manual slug" do
      patch admin_studio_post_path(draft), params: { studio_post: { slug: "custom-slug", meta_title: "MT" } },
                                          headers: admin_auth_headers
      expect(response).to redirect_to(admin_studio_post_path(draft.reload))
      expect(draft.slug).to eq("custom-slug")
      expect(draft.meta_title).to eq("MT")
    end
  end

  describe "DELETE /admin/studio/posts/:id" do
    it "destroys with admin auth" do
      post_record
      expect {
        delete admin_studio_post_path(post_record), headers: admin_auth_headers
      }.to change(Studio::Post, :count).by(-1)
    end
  end
end
