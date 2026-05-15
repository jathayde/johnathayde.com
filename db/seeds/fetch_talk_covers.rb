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

labels = {
  attached:         "✓ attached",
  already_attached: "· already had a cover",
  no_deck_id:       "? no parseable deck id (embed not recognized)",
  failed:           "✗ fetch failed"
}

with_embed    = Talk.where.not(speaker_deck_embed: [nil, ""])
without_embed = Talk.where(speaker_deck_embed: [nil, ""]).left_joins(:cover_image_attachment)
                    .where(active_storage_attachments: { id: nil })

puts "Fetching covers for #{with_embed.count} talk(s) with embeds..."
with_embed.find_each do |talk|
  result = SpeakerDeck::CoverFetcher.call(talk)
  puts "  #{labels[result].ljust(40)} #{talk.title}"
end

if without_embed.any?
  puts
  puts "#{without_embed.count} talk(s) need manual cover (no embed set on the talk):"
  without_embed.each { |t| puts "  - #{t.title}" }
end

attached_total = Talk.joins(:cover_image_attachment).count
puts
puts "#{attached_total} of #{Talk.count} talk(s) now have a cover attached."
