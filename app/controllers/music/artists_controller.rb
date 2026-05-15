# frozen_string_literal: true

class Music::ArtistsController < ApplicationController
  def show
    @artist = Music::Artist.friendly.find(params[:id])
    @recordings = @artist.recordings.includes(:tracks, cover_image_attachment: :blob)
    @videos = @artist.videos
  end
end
