# frozen_string_literal: true

# Bulk-fetches the first-slide cover image from SpeakerDeck for every talk
# with an embed snippet. Idempotent: skips talks that already have a cover
# attached. Run with:
#
#   bin/rails runner db/seeds/fetch_talk_covers.rb
#
# On Dokku:
#
#   dokku run johnathayde bundle exec rails runner db/seeds/fetch_talk_covers.rb

talks = Talk.where.not(speaker_deck_embed: [nil, ""])
puts "Fetching covers for #{talks.count} talk(s)..."

talks.find_each do |talk|
  result = SpeakerDeck::CoverFetcher.call(talk)
  label = {
    attached:         "✓ attached",
    already_attached: "· already had a cover",
    no_deck_id:       "? no parseable deck id (embed not recognized)",
    failed:           "✗ fetch failed"
  }[result]
  puts "  #{label.ljust(40)} #{talk.title}"
end

attached = Talk.joins(:cover_image_attachment).count
puts "Done. #{attached} talk(s) now have a cover attached."
