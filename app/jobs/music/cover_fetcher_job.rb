# frozen_string_literal: true

# Runs Music::CoverFetcher asynchronously so the admin save isn't blocked
# by the iTunes / MusicBrainz round-trips. The fetcher's own idempotency
# guards (`:noop` when cover and apple_music_url are both set) make this
# safe to enqueue from after_save_commit without extra checks.
module Music
  class CoverFetcherJob < ApplicationJob
    queue_as :default

    def perform(recording_id)
      recording = Music::Recording.find_by(id: recording_id)
      return unless recording

      Music::CoverFetcher.call(recording)
    end
  end
end
