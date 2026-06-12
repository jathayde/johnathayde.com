# frozen_string_literal: true

module BlogHelper
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
