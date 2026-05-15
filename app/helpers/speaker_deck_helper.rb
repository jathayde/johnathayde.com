# frozen_string_literal: true

module SpeakerDeckHelper
  DEFAULT_RATIO = "1.7777777778" # 16:9

  # Renders a SpeakerDeck embed. Accepts the legacy <script class="speakerdeck-embed">
  # snippet (which we still have in seeds) and parses data-id / data-ratio out
  # of it so we can emit a plain iframe -- SpeakerDeck retired the JS embed.
  # If the stored value doesn't match the script pattern (e.g. someone pasted
  # an iframe directly), it's rendered as-is, since admin content is trusted.
  def speaker_deck_embed(embed)
    return if embed.blank?

    deck_id, ratio = parse_speaker_deck(embed)
    return raw(embed) unless deck_id

    aspect = (ratio.presence || DEFAULT_RATIO)
    content_tag(:div, class: "speaker-deck-embed", style: "aspect-ratio: #{aspect};") do
      tag.iframe(
        src: "https://speakerdeck.com/player/#{deck_id}",
        title: "SpeakerDeck slides",
        allow: "fullscreen",
        allowfullscreen: true,
        loading: "lazy"
      )
    end
  end

  private

  def parse_speaker_deck(embed)
    return [nil, nil] unless embed =~ /speakerdeck-embed/i

    id    = embed[/data-id=["']([^"']+)["']/i, 1]
    ratio = embed[/data-ratio=["']([\d.]+)["']/i, 1]
    [id, ratio]
  end
end
