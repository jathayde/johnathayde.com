# frozen_string_literal: true

require "net/http"
require "json"

# Best-effort album cover lookup with two backends:
#   1. iTunes Search API — fast, also yields an Apple Music URL we can stash
#      on the recording.
#   2. MusicBrainz + Cover Art Archive — fallback for indie releases iTunes
#      doesn't have.
#
# No API keys required for either. Updates already-present fields only when
# they're blank (so admin edits aren't clobbered on re-run).
module Music
  class CoverFetcher
    ITUNES_SEARCH_URL = "https://itunes.apple.com/search"
    MUSICBRAINZ_URL   = "https://musicbrainz.org/ws/2/release/"
    COVER_ART_URL     = "https://coverartarchive.org/release"
    UA = "johnathayde.com cover-fetcher (contact: john@johnathayde.com)"

    def self.call(recording, source_url: nil, force: false)
      new(recording).call(source_url: source_url, force: force)
    end

    def initialize(recording)
      @recording = recording
    end

    # Returns one of :attached, :enriched, :noop, :failed for the caller to log.
    def call(source_url: nil, force: false)
      cover_done = @recording.cover_image.attached? && !force
      metadata_done = @recording.apple_music_url.present?

      return :noop if cover_done && metadata_done

      enriched = metadata_done ? false : enrich_metadata
      return :enriched if cover_done && enriched

      if cover_done
        return enriched ? :enriched : :noop
      end

      url = source_url.presence || lookup_itunes_artwork || lookup_musicbrainz_artwork
      return enriched ? :enriched : :noop if url.blank?

      attach_from_url(url) ? :attached : :failed
    rescue StandardError => e
      Rails.logger.warn("[CoverFetcher] #{@recording.artist.name} - #{@recording.title}: #{e.message}")
      :failed
    end

    private

    # ---------- iTunes ----------

    # Returns true if it wrote anything.
    def enrich_metadata
      result = itunes_match
      return false unless result

      updates = {}
      if @recording.apple_music_url.blank? && result["collectionViewUrl"].present?
        updates[:apple_music_url] = result["collectionViewUrl"].sub(/\?.*$/, "")
      end
      return false if updates.empty?

      if @recording.persisted?
        @recording.update_columns(updates)
      else
        @recording.assign_attributes(updates)
      end
      true
    end

    def lookup_itunes_artwork
      result = itunes_match
      return nil unless result

      upscale_artwork(result["artworkUrl100"])
    end

    def itunes_match
      @itunes_match ||= begin
        params = { term: "#{@recording.artist.name} #{@recording.title}", entity: "album", limit: 10 }
        uri = URI(ITUNES_SEARCH_URL)
        uri.query = URI.encode_www_form(params)
        response = http_get(uri)
        return nil unless response.is_a?(Net::HTTPSuccess)

        results = JSON.parse(response.body)["results"]
        pick_itunes_match(results)
      end
    end

    def pick_itunes_match(results)
      return nil if results.blank?

      artist_norm = normalize(@recording.artist.name)
      title_norm  = normalize(@recording.title)

      # Strict: both artist and (a non-trivial prefix of) title must match.
      results.find do |r|
        normalize(r["artistName"].to_s).include?(artist_norm) &&
          normalize(r["collectionName"].to_s).include?(title_norm[0, 8])
      end
    end

    def upscale_artwork(url)
      return nil if url.blank?

      url.sub("100x100bb", "1200x1200bb").sub("100x100", "1200x1200")
    end

    # ---------- MusicBrainz + Cover Art Archive ----------

    def lookup_musicbrainz_artwork
      mbid = lookup_musicbrainz_mbid
      return nil unless mbid

      # 302 redirects to the actual image; we follow.
      cover_uri = URI("#{COVER_ART_URL}/#{mbid}/front")
      response = http_get(cover_uri)
      response.is_a?(Net::HTTPSuccess) ? cover_uri.to_s : nil
    end

    def lookup_musicbrainz_mbid
      query = %(artist:"#{escape_lucene(@recording.artist.name)}" AND release:"#{escape_lucene(@recording.title)}")
      uri = URI(MUSICBRAINZ_URL)
      uri.query = URI.encode_www_form(query: query, fmt: "json", limit: 5)

      # MusicBrainz politely asks for 1 req/sec.
      sleep 1.0

      response = http_get(uri)
      return nil unless response.is_a?(Net::HTTPSuccess)

      releases = JSON.parse(response.body)["releases"] || []
      best = releases.max_by { |r| r["score"].to_i }
      best && best["score"].to_i >= 90 ? best["id"] : nil
    end

    def escape_lucene(str)
      str.to_s.gsub(/([+\-!(){}\[\]^"~*?:\\\/])/, '\\\\\1')
    end

    # ---------- shared ----------

    def normalize(str)
      str.downcase.gsub(/[^a-z0-9]/, "")
    end

    def attach_from_url(url)
      uri = URI(url)
      response = http_get(uri)
      return false unless response.is_a?(Net::HTTPSuccess)

      ext = File.extname(uri.path).presence || ".jpg"
      filename = "#{@recording.artist.name.parameterize}-#{@recording.title.parameterize}#{ext}"

      @recording.cover_image.attach(
        io: StringIO.new(response.body),
        filename: filename,
        content_type: response["content-type"].to_s.split(";").first.presence || "image/jpeg"
      )
      true
    end

    def http_get(uri, redirects_left: 5)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 5, read_timeout: 20) do |http|
        request = Net::HTTP::Get.new(uri.request_uri, "User-Agent" => UA)
        response = http.request(request)

        if response.is_a?(Net::HTTPRedirection) && redirects_left.positive?
          http_get(URI(response["location"]), redirects_left: redirects_left - 1)
        else
          response
        end
      end
    end
  end
end
