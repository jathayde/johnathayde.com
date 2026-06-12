json.title @article.title
json.subtitle @article.subtitle
json.author @article.author.presence || "John Athayde"
json.slug @article.slug
json.published_at @article.published_at&.iso8601
json.updated_at @article.updated_at.iso8601
json.category @article.category&.name
json.tags @article.tag_list.to_a
json.canonical_url @article.canonical_url
json.meta_description @article.meta_description
json.url blog_post_url(@article)
json.markdown_url blog_post_url(@article, format: :md)
json.body_html render(partial: "blog/body", locals: { article: @article }, formats: [:html])
json.body_markdown Blog::MarkdownExporter.new(
  @article,
  body_html: render(partial: "blog/body", locals: { article: @article }, formats: [:html]),
  url: blog_post_url(@article)
).to_markdown
