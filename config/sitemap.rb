require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  fog_directory: ENV['FOG_DIRECTORY'],
  fog_region: ENV['FOG_REGION']
)

SitemapGenerator::Sitemap.default_host = "https://www.johnathayde.com"
SitemapGenerator::Sitemap.public_path  = 'tmp/'
SitemapGenerator::Sitemap.adapter      = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Root is added automatically (include_root defaults to true); don't add it again.
  add '/contact', changefreq: 'monthly'
  add '/resume',  changefreq: 'monthly'

  # Music
  add '/music',          changefreq: 'monthly', priority: 0.8
  add '/music/timeline', changefreq: 'monthly'
  Music::Artist.find_each do |artist|
    add "/music/#{artist.slug}", changefreq: 'monthly', lastmod: artist.updated_at
  end

  # Speaking
  add '/speaking',              changefreq: 'monthly', priority: 0.8
  add '/speaking/appearances',  changefreq: 'monthly'
  add '/speaking/talks',        changefreq: 'monthly'
  # Slugs are not unique across appearances (e.g. a recurring meetup); one URL each.
  Appearance.order(updated_at: :desc).find_each.uniq { |a| a.slug || a.id }.each do |appearance|
    add "/speaking/appearances/#{appearance.slug || appearance.id}",
        changefreq: 'monthly', lastmod: appearance.updated_at
  end
  Talk.find_each do |talk|
    add "/speaking/talks/#{talk.slug || talk.id}",
        changefreq: 'monthly', lastmod: talk.updated_at
  end

  # Blog
  add '/blog', changefreq: 'weekly', priority: 0.8
  # Posts whose canonical points elsewhere (cross-posts) are intentionally
  # non-canonical here and must not be listed.
  Article.live.where(canonical_url: [nil, '']).find_each do |article|
    add "/blog/#{article.slug || article.id}",
        changefreq: 'monthly', lastmod: article.updated_at
  end
  Category.joins(:articles).merge(Article.live).distinct.find_each do |category|
    add "/blog/category/#{category.slug}", changefreq: 'weekly'
  end
  ActsAsTaggableOn::Tag
    .joins(:taggings)
    .where(taggings: { taggable_type: 'Article', taggable_id: Article.visible_on_index.select(:id) })
    .distinct
    .find_each do |tag|
    add blog_tag_path(tag: tag.name), changefreq: 'weekly'
  end

  # Work
  add '/work',                     changefreq: 'monthly'
  add '/work/livingsocial-csr',    changefreq: 'monthly'
  add '/work/navanti-pulse',       changefreq: 'monthly'
  add '/work/procore',             changefreq: 'monthly'
  add '/work/powerfleet-chassis',  changefreq: 'monthly'
  add '/work/powerfleet-rebrand',  changefreq: 'monthly'
  add '/work/rails-guides',        changefreq: 'monthly'
end

SitemapGenerator::Sitemap.ping_search_engines
