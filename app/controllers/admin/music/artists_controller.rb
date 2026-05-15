# frozen_string_literal: true

class Admin::Music::ArtistsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_artist, only: %i[show edit update destroy]

  def index
    @artists = Music::Artist.ordered.includes(:recordings, :videos)
  end

  def show
    @recordings = @artist.recordings
    @videos = @artist.videos
  end

  def new
    @artist = Music::Artist.new(position: next_position)
  end

  def edit; end

  def create
    @artist = Music::Artist.new(artist_params)
    @artist.position ||= next_position
    if @artist.save
      redirect_to admin_music_artist_url(@artist), notice: "Artist created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @artist.update(artist_params)
      redirect_to admin_music_artist_url(@artist), notice: "Artist updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @artist.destroy
    redirect_to admin_music_artists_url, notice: "Artist deleted."
  end

  def reorder
    Array(params[:ids]).each_with_index do |id, index|
      Music::Artist.where(id: id).update_all(position: index)
    end
    head :no_content
  end

  private

  def set_artist
    @artist = Music::Artist.friendly.find(params[:id])
  end

  def next_position
    (Music::Artist.maximum(:position) || -1) + 1
  end

  def artist_params
    params.require(:music_artist).permit(
      :name, :url, :instagram_url, :facebook_url, :twitter_url, :youtube_url,
      :bandcamp_url, :spotify_url, :apple_music_url, :soundcloud_url,
      :active_from, :active_to, :john_from, :john_to, :john_role,
      :position, :description, :feature_photo
    )
  end
end
