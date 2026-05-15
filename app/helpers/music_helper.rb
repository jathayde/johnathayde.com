# frozen_string_literal: true

module MusicHelper
  YOUTUBE_HOSTS = %w[youtube.com www.youtube.com m.youtube.com youtu.be youtube-nocookie.com www.youtube-nocookie.com].freeze

  # Normalizes a YouTube/Vimeo URL (or pasted iframe snippet) into a responsive
  # iframe. Falls through to raw HTML if an iframe snippet is supplied, since
  # admin content is trusted.
  def music_video_embed(video)
    return if video.blank?

    if video.embed_code.present?
      content_tag(:div, raw(video.embed_code), class: "music-video-embed")
    elsif (id = youtube_id(video.url))
      iframe_wrapper("https://www.youtube-nocookie.com/embed/#{id}")
    elsif (id = vimeo_id(video.url))
      iframe_wrapper("https://player.vimeo.com/video/#{id}")
    else
      content_tag(:p, link_to("Watch video", video.url, target: "_blank", rel: "noopener"))
    end
  end

  # Recording media: pasted Bandcamp/Spotify embed if any, otherwise cover art.
  def music_recording_embed(recording)
    if recording.embed_code.present?
      content_tag(:div, raw(recording.embed_code), class: "music-recording-embed")
    elsif recording.cover_image.attached?
      image_tag(recording.cover_image, alt: "#{recording.title} cover", class: "music-recording-cover")
    end
  end

  def youtube_id(url)
    return nil if url.blank?

    uri = URI.parse(url)
    return nil unless YOUTUBE_HOSTS.include?(uri.host)

    if uri.host.include?("youtu.be")
      uri.path[1..]
    elsif uri.path.start_with?("/embed/", "/v/")
      uri.path.split("/")[2]
    elsif uri.path == "/watch"
      Rack::Utils.parse_query(uri.query)["v"]
    end
  rescue URI::InvalidURIError
    nil
  end

  def vimeo_id(url)
    return nil if url.blank?

    uri = URI.parse(url)
    return nil unless uri.host&.include?("vimeo.com")

    uri.path.split("/").last.presence
  rescue URI::InvalidURIError
    nil
  end

  private

  def iframe_wrapper(src)
    content_tag(:div, class: "music-video-embed") do
      tag.iframe(src: src, allow: "fullscreen", allowfullscreen: true, loading: "lazy", title: "Video")
    end
  end
end
