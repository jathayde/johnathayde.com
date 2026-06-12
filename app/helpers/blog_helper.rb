# frozen_string_literal: true

module BlogHelper
  # Truncate rendered rich-text HTML to a word budget while keeping the
  # markup intact (tags balanced, formatting preserved). Input is our own
  # ActionText-rendered HTML, so it is already sanitized.
  def excerpt_html(html, words: 300)
    HTML_Truncator.truncate(html.to_s, words, ellipsis: "…").html_safe # rubocop:disable Rails/OutputSafety
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
