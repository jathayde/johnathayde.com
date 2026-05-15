# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicHelper, type: :helper do
  describe "#youtube_id" do
    it "extracts the id from a watch URL" do
      expect(helper.youtube_id("https://www.youtube.com/watch?v=dQw4w9WgXcQ")).to eq("dQw4w9WgXcQ")
    end

    it "extracts the id from a youtu.be short URL" do
      expect(helper.youtube_id("https://youtu.be/dQw4w9WgXcQ")).to eq("dQw4w9WgXcQ")
    end

    it "extracts the id from an embed URL" do
      expect(helper.youtube_id("https://www.youtube.com/embed/dQw4w9WgXcQ")).to eq("dQw4w9WgXcQ")
    end

    it "returns nil for non-YouTube hosts" do
      expect(helper.youtube_id("https://vimeo.com/12345")).to be_nil
    end

    it "tolerates a blank input" do
      expect(helper.youtube_id(nil)).to be_nil
      expect(helper.youtube_id("")).to be_nil
    end

    it "returns nil for malformed URLs" do
      expect(helper.youtube_id("not a url")).to be_nil
    end
  end

  describe "#vimeo_id" do
    it "extracts the id from a vimeo URL" do
      expect(helper.vimeo_id("https://vimeo.com/123456789")).to eq("123456789")
    end

    it "returns nil for non-Vimeo hosts" do
      expect(helper.vimeo_id("https://www.youtube.com/watch?v=abc")).to be_nil
    end

    it "tolerates a blank input" do
      expect(helper.vimeo_id(nil)).to be_nil
    end
  end

  describe "#music_video_embed" do
    let(:artist) { Music::Artist.create!(name: "Test Band") }

    it "wraps a YouTube watch URL as a youtube-nocookie iframe" do
      video = Music::Video.new(artist: artist, title: "v", url: "https://www.youtube.com/watch?v=abc123")
      html = helper.music_video_embed(video)
      expect(html).to include('class="music-video-embed"')
      expect(html).to include('src="https://www.youtube-nocookie.com/embed/abc123"')
      expect(html).to include("loading=\"lazy\"")
    end

    it "wraps a Vimeo URL as a player iframe" do
      video = Music::Video.new(artist: artist, title: "v", url: "https://vimeo.com/999")
      html = helper.music_video_embed(video)
      expect(html).to include('src="https://player.vimeo.com/video/999"')
    end

    it "renders a pasted embed snippet verbatim" do
      video = Music::Video.new(artist: artist, title: "v", url: "ignored",
                               embed_code: '<iframe src="https://example.com/anything"></iframe>')
      html = helper.music_video_embed(video)
      expect(html).to include('src="https://example.com/anything"')
    end

    it "falls back to a plain link for unknown hosts" do
      video = Music::Video.new(artist: artist, title: "v", url: "https://example.com/clip")
      html = helper.music_video_embed(video)
      expect(html).to include('href="https://example.com/clip"')
      expect(html).not_to include("<iframe")
    end

    it "returns nil for a blank video" do
      expect(helper.music_video_embed(nil)).to be_nil
    end
  end
end
