require 'rails_helper'

RSpec.describe "/studio (public)", type: :request do
  let(:published_post) { FactoryBot.create(:studio_post, :published) }
  let(:draft_post) { FactoryBot.create(:studio_post) }
  let(:scheduled_post) { FactoryBot.create(:studio_post, :scheduled) }

  describe "GET /studio" do
    it "lists only live posts and links to the gear list" do
      published_post
      draft_post
      scheduled_post
      get studio_path
      expect(response).to be_successful
      expect(response.body).to include(published_post.title)
      expect(response.body).not_to include(draft_post.title)
      expect(response.body).not_to include(scheduled_post.title)
      expect(response.body).to include(studio_gear_path)
      expect(response.body).to include(%(rel="canonical" href="http://www.example.com/studio"))
      expect(response.body).to include('property="og:title"')
      expect(response.body).to include('name="twitter:title"')
    end

    it "puts Studio in the primary navigation" do
      get studio_path
      expect(response.body).to include(">Studio</a>")
    end
  end

  describe "GET /studio/:slug" do
    it "shows a published post in the required section order" do
      post = FactoryBot.create(:studio_post, :published, :with_video,
                               verdict: "VerdictToken", signal_chain: "SM57 > 1073 > Apollo",
                               body: "<p>BodyToken</p>")
      item = FactoryBot.create(:studio_gear_item, :affiliate, manufacturer: "Shure", name: "SM57")
      monitors = FactoryBot.create(:studio_gear_item, category: "monitoring", manufacturer: "Yamaha", name: "HS8")
      post.gear_items << [monitors, item]
      FactoryBot.create(:studio_audio_sample, post: post, label: "DryToken")

      get studio_post_path(post)
      expect(response).to be_successful

      body = response.body
      order = [
        "<h1>#{post.title}</h1>",
        %(<figure class="video-embed"><iframe src="https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ"),
        "VerdictToken",
        "DryToken",
        "SM57 &gt; 1073 &gt; Apollo",
        "BodyToken",
        "Shure SM57",
        "Yamaha HS8",
        "affiliate-disclosure"
      ]
      positions = order.map { |token| body.index(token) }
      expect(positions).to all(be_present)
      expect(positions).to eq(positions.sort)
      expect(body.scan("<h1").size).to eq(1)
    end

    it "404s on a draft and a scheduled post" do
      get studio_post_path(draft_post)
      expect(response).to have_http_status(:not_found)
      get studio_post_path(scheduled_post)
      expect(response).to have_http_status(:not_found)
    end

    it "shows a draft to an authenticated admin (preview)" do
      get studio_post_path(draft_post), headers: admin_auth_headers
      expect(response).to be_successful
    end

    it "renders audio samples as inline players with download links" do
      sample = FactoryBot.create(:studio_audio_sample, post: published_post, label: "wet — plate")
      get studio_post_path(published_post)
      expect(response.body).to include("<audio controls")
      expect(response.body).to include("wet — plate")
      expect(response.body).to include("disposition=attachment")
      expect(response.body).to include("Download #{sample.file.filename}")
    end

    it "marks affiliate links as sponsored nofollow and opens them in a new tab, with a disclosure" do
      item = FactoryBot.create(:studio_gear_item, :affiliate)
      published_post.gear_items << item
      get studio_post_path(published_post)
      expect(response.body).to include(%(rel="sponsored nofollow noopener"))
      expect(response.body).to include(%(target="_blank"))
      expect(response.body).to include("affiliate-disclosure")
    end

    it "omits the disclosure when no gear link is an affiliate link" do
      published_post.gear_items << FactoryBot.create(:studio_gear_item)
      get studio_post_path(published_post)
      expect(response.body).not_to include("affiliate-disclosure")
      expect(response.body).to include(studio_gear_path)
    end

    it "hides inactive gear items" do
      published_post.gear_items << FactoryBot.create(:studio_gear_item, :inactive, name: "RetiredToken")
      get studio_post_path(published_post)
      expect(response.body).not_to include("RetiredToken")
    end
  end

  describe "SEO output" do
    it "emits title, description, canonical, og and twitter tags with fallbacks" do
      get studio_post_path(published_post)
      expect(response.body).to include("<title>#{published_post.title}")
      expect(response.body).to include(%(name="description" content="#{published_post.summary}"))
      expect(response.body).to include(%(rel="canonical" href="http://www.example.com/studio/#{published_post.slug}"))
      expect(response.body).to include(%(property="og:title" content="#{published_post.title}"))
      expect(response.body).to include(%(name="twitter:title" content="#{published_post.title}"))
    end

    it "prefers the meta overrides and canonical override when set" do
      post = FactoryBot.create(:studio_post, :published, meta_title: "MetaTitleToken",
                               meta_description: "MetaDescToken", canonical_url: "https://elsewhere.example/p",
                               og_image: "https://elsewhere.example/og.jpg")
      get studio_post_path(post)
      expect(response.body).to include("<title>MetaTitleToken")
      expect(response.body).to include(%(name="description" content="MetaDescToken"))
      expect(response.body).to include(%(rel="canonical" href="https://elsewhere.example/p"))
      expect(response.body).to include(%(property="og:image" content="https://elsewhere.example/og.jpg"))
    end

    it "falls back to the YouTube poster frame for og:image" do
      post = FactoryBot.create(:studio_post, :published, :with_video)
      get studio_post_path(post)
      expect(response.body).to include(%(property="og:image" content="https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg"))
    end

    it "uses the hero image for og:image and sets explicit dimensions on it" do
      post = FactoryBot.create(:studio_post, :published)
      post.hero_image.attach(io: Rails.root.join("spec/fixtures/files/feature.png").open,
                             filename: "feature.png", content_type: "image/png")
      get studio_post_path(post)
      expect(response.body).to match(/property="og:image" content="http/)
      expect(response.body).to include('width="1600" height="900"')
    end

    it "embeds BreadcrumbList and VideoObject JSON-LD when there is a video" do
      post = FactoryBot.create(:studio_post, :published, :with_video)
      get studio_post_path(post)
      expect(response.body).to include('"@type":"BreadcrumbList"')
      expect(response.body).to include('"@type":"VideoObject"')
      expect(response.body).to include('"embedUrl":"https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ"')
    end

    it "emits BreadcrumbList but no VideoObject without a video" do
      get studio_post_path(published_post)
      expect(response.body).to include('"@type":"BreadcrumbList"')
      expect(response.body).not_to include('"@type":"VideoObject"')
    end
  end

  describe "GET /studio/gear" do
    it "groups active gear by category in signal-chain order with ItemList JSON-LD" do
      FactoryBot.create(:studio_gear_item, category: "monitoring", name: "MonitorToken")
      FactoryBot.create(:studio_gear_item, :affiliate, category: "mics", name: "MicToken")
      FactoryBot.create(:studio_gear_item, :inactive, category: "preamps", name: "HiddenToken")

      get studio_gear_path
      expect(response).to be_successful
      expect(response.body).to include("MicToken")
      expect(response.body).to include("MonitorToken")
      expect(response.body).not_to include("HiddenToken")
      expect(response.body.index("Microphones")).to be < response.body.index("Monitoring")
      expect(response.body).to include('"@type":"ItemList"')
      expect(response.body).to include('"numberOfItems":2')
      expect(response.body).to include(%(rel="sponsored nofollow noopener"))
      expect(response.body).to include("affiliate-disclosure")
      expect(response.body).to include(%(rel="canonical" href="http://www.example.com/studio/gear"))
    end

    it "links gear back to the live posts that feature it" do
      item = FactoryBot.create(:studio_gear_item, name: "LinkedToken")
      published_post.gear_items << item
      draft_post.gear_items << item
      get studio_gear_path
      expect(response.body).to include("Featured in:")
      expect(response.body).to include(published_post.title)
      expect(response.body).not_to include(draft_post.title)
    end

    it "is not shadowed by the post slug route" do
      get "/studio/gear"
      expect(response).to be_successful
      expect(response.body).to include("<h1>Gear</h1>")
    end
  end
end
