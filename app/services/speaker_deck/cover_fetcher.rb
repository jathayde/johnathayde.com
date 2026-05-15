# frozen_string_literal: true

require "net/http"

# Fetches the first-slide thumbnail from SpeakerDeck for a Talk's embed
# snippet and attaches it as the talk's cover_image. SpeakerDeck publishes
# decks at a predictable path:
#
#   https://files.speakerdeck.com/presentations/<data-id>/slide_0.jpg
#
# Returns one of :attached, :noop, :failed.
module SpeakerDeck
  class CoverFetcher
    UA = "johnathayde.com cover-fetcher"
    SLIDE_URL = "https://files.speakerdeck.com/presentations/%<id>s/slide_0.jpg"

    def self.call(talk, force: false)
      new(talk).call(force: force)
    end

    def initialize(talk)
      @talk = talk
    end

    def call(force: false)
      return :already_attached if @talk.cover_image.attached? && !force

      id = parse_deck_id
      return :no_deck_id if id.blank?

      attach(id) ? :attached : :failed
    rescue StandardError => e
      Rails.logger.warn("[SpeakerDeck::CoverFetcher] #{@talk.title}: #{e.message}")
      :failed
    end

    private

    # Tries, in order:
    #   1. Legacy script tag:   data-id="abc123"
    #   2. Modern iframe src:   speakerdeck.com/player/abc123
    #   3. Public deck URL:     speakerdeck.com/<user>/<slug> (resolves via Location header)
    def parse_deck_id
      embed = @talk.speaker_deck_embed.to_s
      return nil if embed.blank?

      embed[/data-id=["']([^"']+)["']/i, 1] ||
        embed[%r{speakerdeck\.com/player/([a-f0-9]+)}i, 1] ||
        resolve_public_url(embed)
    end

    # When the embed contains a bare public URL (speakerdeck.com/<user>/<slug>),
    # SpeakerDeck redirects /<user>/<slug> -> /player/<id> when fetched. Pull the
    # id out of that Location header.
    def resolve_public_url(embed)
      url = embed[%r{https?://speakerdeck\.com/[\w-]+/[\w-]+}i]
      return nil unless url

      uri = URI(url)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 10) do |http|
        http.head(uri.request_uri, "User-Agent" => UA)
      end
      location = response["location"].to_s
      location[%r{/player/([a-f0-9]+)}, 1]
    rescue StandardError
      nil
    end

    def attach(id)
      uri = URI(format(SLIDE_URL, id: id))
      response = http_get(uri)
      return false unless response.is_a?(Net::HTTPSuccess) && response.body.bytesize.positive?

      filename = "#{@talk.slug}-slide-0.jpg"
      @talk.cover_image.attach(
        io: StringIO.new(response.body),
        filename: filename,
        content_type: "image/jpeg"
      )
      true
    end

    def http_get(uri, redirects_left: 3)
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
