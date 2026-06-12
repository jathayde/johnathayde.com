# frozen_string_literal: true

module BlogHelper
  # Truncate rendered rich-text HTML to a word budget while keeping the
  # markup intact (tags balanced, formatting preserved). Input is our own
  # ActionText-rendered HTML, so it is already sanitized.
  def excerpt_html(html, words: 150)
    HTML_Truncator.truncate(html.to_s, words, ellipsis: "…").html_safe # rubocop:disable Rails/OutputSafety
  end

  # Replace bare YouTube/Vimeo links (a paragraph containing just the URL,
  # as Lexxy stores a pasted link) in rendered rich text with responsive
  # iframe embeds. The editor can't store iframes — and the Action Text
  # sanitizer would strip them anyway — so embeds are generated at render
  # time from URLs we parse ourselves.
  def embed_video_links(html)
    fragment = Nokogiri::HTML.fragment(html.to_s)

    fragment.css("a[href]").each do |link|
      next unless link.text.strip == link["href"].to_s.strip

      embed = video_embed_for(link["href"])
      next unless embed

      # If the link is alone in its paragraph, replace the whole paragraph
      paragraph = link.parent
      target = paragraph&.name == "p" && paragraph.text.strip == link.text.strip ? paragraph : link
      target.replace(embed)
    end

    fragment.to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def video_embed_for(url)
    case url
    when %r{\Ahttps?://(?:www\.)?youtube(?:-nocookie)?\.com/(?:watch\?v=|embed/)([\w-]+)},
         %r{\Ahttps?://youtu\.be/([\w-]+)}
      video_embed_iframe("https://www.youtube-nocookie.com/embed/#{Regexp.last_match(1)}", "YouTube video")
    when %r{\Ahttps?://(?:www\.)?vimeo\.com/(\d+)}
      video_embed_iframe("https://player.vimeo.com/video/#{Regexp.last_match(1)}", "Vimeo video")
    end
  end

  def video_embed_iframe(src, title)
    <<~HTML
      <figure class="video-embed"><iframe src="#{src}" title="#{title}" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe></figure>
    HTML
  end

  # Absolute URL for social cards (og:image / twitter:image): the uploaded
  # feature image when present, otherwise the stored override URLs.
  def article_social_image_url(article)
    if article.feature_image.attached?
      request.base_url + rails_representation_path(article.feature_image.variant(:og))
    else
      article.og_image.presence || article.img_source.presence
    end
  end
end
