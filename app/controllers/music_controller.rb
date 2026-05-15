# frozen_string_literal: true

class MusicController < ApplicationController
  def index
    @artists = Music::Artist.ordered.includes(:recordings, :videos, feature_photo_attachment: :blob)
  end

  def timeline
    recordings = Music::Recording.includes(:artist, cover_image_attachment: :blob)
                                 .order(release_year: :desc, release_date: :desc)
    videos = Music::Video.includes(:artist).where.not(performed_on: nil).order(performed_on: :desc)

    @timeline = (recordings.to_a + videos.to_a).sort_by do |item|
      date = item.is_a?(Music::Recording) ? item.display_date : item.performed_on
      [-date.to_time.to_i, item.is_a?(Music::Recording) ? 0 : 1]
    end
  end
end
