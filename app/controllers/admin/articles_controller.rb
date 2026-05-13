# frozen_string_literal: true

class Admin::ArticlesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.order(created_at: :desc)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to admin_article_url(@article), notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @article.update(article_params)
      redirect_to admin_article_url(@article), notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_articles_url, notice: "Article was successfully destroyed."
  end

  private

  def set_article
    @article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(
      :title, :subtitle, :author, :body, :page_title, :meta_description,
      :published_at, :hidden_on_index, :img_source,
      :og_title, :og_description, :og_image,
      :twitter_title, :twitter_description, :twitter_image
    )
  end
end
