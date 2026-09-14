# frozen_string_literal: true

class Admin::Studio::PostsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Studio::Post.order(created_at: :desc)
  end

  def show
    @audio_samples = @post.audio_samples.includes(file_attachment: :blob)
  end

  def new
    @post = Studio::Post.new
  end

  def edit; end

  def create
    @post = Studio::Post.new(post_params)
    if @post.save
      redirect_to admin_studio_post_url(@post), notice: "Post created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @post.update(post_params)
      redirect_to admin_studio_post_url(@post), notice: "Post updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_studio_posts_url, notice: "Post deleted."
  end

  private

  def set_post
    @post = Studio::Post.friendly.find(params[:id])
  end

  def post_params
    params.require(:studio_post).permit(
      :title, :slug, :summary, :category, :youtube_id, :verdict, :signal_chain, :body,
      :hero_image, :status, :published_at,
      :meta_title, :meta_description, :og_image, :canonical_url,
      gear_item_ids: []
    )
  end
end
