# frozen_string_literal: true

class Admin::Music::TracksController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_recording
  before_action :set_track, only: %i[edit update destroy]

  def index
    @tracks = @recording.tracks
  end

  def new
    @track = @recording.tracks.new
  end

  def edit; end

  def create
    @track = @recording.tracks.new(track_params)
    if @track.save
      redirect_to admin_music_recording_url(@recording), notice: "Track added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @track.update(track_params)
      redirect_to admin_music_recording_url(@recording), notice: "Track updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @track.destroy
    redirect_to admin_music_recording_url(@recording), notice: "Track removed."
  end

  private

  def set_recording
    @recording = Music::Recording.find(params[:recording_id])
  end

  def set_track
    @track = @recording.tracks.find(params[:id])
  end

  def track_params
    params.require(:music_track).permit(
      :title, :track_number, :john_role, :notes,
      :spotify_url, :apple_music_url, :bandcamp_url, :youtube_url
    )
  end
end
