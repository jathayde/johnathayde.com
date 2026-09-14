# frozen_string_literal: true

class Admin::Studio::AudioSamplesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_post, only: %i[new create]
  before_action :set_audio_sample, only: %i[edit update destroy]

  def new
    @audio_sample = @post.audio_samples.new(position: next_position)
  end

  def edit; end

  def create
    @audio_sample = @post.audio_samples.new(audio_sample_params)
    if @audio_sample.save
      redirect_to admin_studio_post_url(@post), notice: "Audio sample added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @audio_sample.update(audio_sample_params)
      redirect_to admin_studio_post_url(@audio_sample.post), notice: "Audio sample updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    post = @audio_sample.post
    @audio_sample.destroy
    redirect_to admin_studio_post_url(post), notice: "Audio sample removed."
  end

  private

  def set_post
    @post = Studio::Post.friendly.find(params[:post_id])
  end

  def set_audio_sample
    @audio_sample = Studio::AudioSample.find(params[:id])
  end

  def next_position
    (@post.audio_samples.maximum(:position) || -1) + 1
  end

  def audio_sample_params
    params.require(:studio_audio_sample).permit(:label, :position, :file)
  end
end
