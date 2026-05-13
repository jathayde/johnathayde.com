# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    @articles = Article.visible_on_index
  end

  def show
    @article = Article.friendly.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @article.published?
  end
end
