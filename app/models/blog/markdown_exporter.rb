# frozen_string_literal: true

# Renders an article as Markdown with YAML front matter, for the blog's
# .md format and llms.txt consumers.
#
# Takes the rendered body HTML (not article.body.to_s) so that Action Text
# attachments arrive already resolved to absolute image URLs — render the
# "blog/body" partial in controller/view context and pass the result in.
module Blog
  class MarkdownExporter
    def initialize(article, body_html:, url:)
      @article = article
      @body_html = body_html
      @url = url
    end

    def to_markdown
      "#{front_matter}\n#{body_markdown}"
    end

    private

    def front_matter
      {
        "title" => @article.title,
        "subtitle" => @article.subtitle,
        "author" => @article.author.presence || "John Athayde",
        "slug" => @article.slug,
        "date" => @article.published_at&.iso8601,
        "category" => @article.category&.name,
        "tags" => @article.tag_list.to_a.presence,
        "canonical_url" => @article.canonical_url,
        "url" => @url
      }.compact.to_yaml + "---\n"
    end

    def body_markdown
      ReverseMarkdown.convert(@body_html.to_s, unknown_tags: :bypass, github_flavored: true)
    end
  end
end
