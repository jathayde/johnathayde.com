atom_feed(root_url: blog_url) do |feed|
  feed.title "John Athayde — Blog"
  feed.subtitle "Writing on product design, Rails, and building things."
  feed.updated @articles.first&.published_at || Time.current

  @articles.each do |article|
    feed.entry article, url: blog_post_url(article),
                        published: article.published_at,
                        updated: article.updated_at do |entry|
      entry.title article.title
      entry.summary article.meta_description
      entry.content render(partial: "blog/body", locals: { article: article }, formats: [:html]), type: "html"
      entry.author do |author|
        author.name(article.author.presence || "John Athayde")
      end
    end
  end
end
