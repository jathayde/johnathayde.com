# frozen_string_literal: true

module StudioHelper
  # Absolute URL for social cards: the uploaded hero image when present,
  # otherwise the og:image override, otherwise the YouTube poster frame.
  def studio_post_social_image_url(post)
    if post.hero_image.attached?
      request.base_url + rails_representation_path(post.hero_image.variant(:og))
    else
      post.og_image.presence || post.youtube_thumbnail_url
    end
  end

  # Affiliate links carry rel="sponsored nofollow" so search engines treat
  # them as paid, and open in a new tab. Non-affiliate items render as text.
  def gear_item_link(item, text = item.display_name)
    if item.affiliate?
      link_to text, item.affiliate_url, rel: "sponsored nofollow noopener", target: "_blank"
    else
      text
    end
  end

  def studio_youtube_embed(post)
    return if post.youtube_id.blank?

    # video_embed_iframe builds the markup from our own values only.
    video_embed_iframe(post.youtube_embed_url, post.title).html_safe # rubocop:disable Rails/OutputSafety
  end
end
