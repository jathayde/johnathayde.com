# frozen_string_literal: true

class BlogController < ApplicationController
  def index
    @articles = Article.visible_on_index
  end

  def show
    @article = Article.friendly.find(params[:slug])
    raise ActiveRecord::RecordNotFound unless @article.live? || admin?

    respond_to do |format|
      format.html
      format.md { render plain: markdown_for(@article), content_type: "text/markdown" }
      format.json
    end
  end

  def category
    @category = Category.friendly.find(params[:slug])
    @articles = @category.articles.visible_on_index
  end

  def tag
    @tag = ActsAsTaggableOn::Tag.find_by!(name: params[:tag])
    @articles = Article.visible_on_index.tagged_with(@tag.name)
  end

  def feed
    @articles = Article.visible_on_index.limit(20)
  end

  def llms
    @articles = Article.visible_on_index
    render formats: [:text]
  end

  private

  def markdown_for(article)
    body_html = render_to_string(partial: "blog/body", locals: { article: article }, formats: [:html])
    Blog::MarkdownExporter.new(article, body_html: body_html, url: blog_post_url(article)).to_markdown
  end
end
