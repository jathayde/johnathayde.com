# frozen_string_literal: true

class Admin::Music::RecordingsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_artist, only: %i[new create]
  before_action :set_recording, only: %i[show edit update destroy fetch_cover]

  def show
    @tracks = @recording.tracks
  end

  def new
    @recording = @artist.recordings.new(release_year: Date.current.year)
  end

  def edit; end

  def create
    @recording = @artist.recordings.new(recording_params)
    if @recording.save
      redirect_to admin_music_recording_url(@recording), notice: "Recording created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @recording.update(recording_params)
      redirect_to admin_music_recording_url(@recording), notice: "Recording updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    artist = @recording.artist
    @recording.destroy
    redirect_to admin_music_artist_url(artist), notice: "Recording deleted."
  end

  def fetch_cover
    result = Music::CoverFetcher.call(@recording, force: true)
    notice = case result
             when :attached then "Pulled cover art for #{@recording.title}."
             when :enriched then "Captured Apple Music URL (no cover image found)."
             when :noop     then "Nothing new -- iTunes and MusicBrainz didn't return a match."
             when :failed   then "Lookup failed. Try uploading the cover manually."
             end
    redirect_to admin_music_recording_url(@recording), notice: notice
  end

  private

  def set_artist
    @artist = Music::Artist.friendly.find(params[:artist_id])
  end

  def set_recording
    @recording = Music::Recording.find(params[:id])
  end

  def recording_params
    params.require(:music_recording).permit(
      :title, :release_year, :release_date, :kind, :john_role_override, :notes,
      :spotify_url, :apple_music_url, :bandcamp_url, :soundcloud_url, :youtube_url,
      :embed_code, :cover_image
    )
  end
end
