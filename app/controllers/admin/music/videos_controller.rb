# frozen_string_literal: true

class Admin::Music::VideosController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_artist, only: %i[new create]
  before_action :set_video, only: %i[edit update destroy]

  def new
    @video = @artist.videos.new
  end

  def edit; end

  def create
    @video = @artist.videos.new(video_params)
    if @video.save
      redirect_to admin_music_artist_url(@artist), notice: "Video added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @video.update(video_params)
      redirect_to admin_music_artist_url(@video.artist), notice: "Video updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    artist = @video.artist
    @video.destroy
    redirect_to admin_music_artist_url(artist), notice: "Video removed."
  end

  private

  def set_artist
    @artist = Music::Artist.friendly.find(params[:artist_id])
  end

  def set_video
    @video = Music::Video.find(params[:id])
  end

  def video_params
    params.require(:music_video).permit(:title, :kind, :performed_on, :url, :embed_code, :notes)
  end
end
