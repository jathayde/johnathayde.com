require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  fog_directory: ENV['FOG_DIRECTORY'],
  fog_region: ENV['FOG_REGION']
)

SitemapGenerator::Sitemap.default_host = 'https://johnathayde.com'
SitemapGenerator::Sitemap.public_path  = 'tmp/'
SitemapGenerator::Sitemap.adapter      = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add '/',        changefreq: 'weekly',  priority: 0.9
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
  Appearance.find_each do |appearance|
    add "/speaking/appearances/#{appearance.slug || appearance.id}",
        changefreq: 'monthly', lastmod: appearance.updated_at
  end
  Talk.find_each do |talk|
    add "/speaking/talks/#{talk.slug || talk.id}",
        changefreq: 'monthly', lastmod: talk.updated_at
  end

  # Articles
  Article.where.not(published_at: nil).find_each do |article|
    add "/articles/#{article.slug || article.id}",
        changefreq: 'monthly', lastmod: article.updated_at
  end

  # Work
  add '/work',                     changefreq: 'monthly'
  add '/work/livingsocial-csr',    changefreq: 'monthly'
  add '/work/navanti-pulse',       changefreq: 'monthly'
  add '/work/procore',             changefreq: 'monthly'
  add '/work/powerfleet-chassis',  changefreq: 'monthly'
end

SitemapGenerator::Sitemap.ping_search_engines
