# frozen_string_literal: true

# Seeds for the music side of the site. Run with:
#   bin/rails runner 'load Rails.root.join("db/seeds/music.rb").to_s'
# or include from db/seeds.rb. Idempotent: looks up artists/recordings by
# slug-equivalent keys before creating.
#
# Cover art is fetched best-effort from the iTunes Search API by
# Music::CoverFetcher. Records without a hit (Rotoscope demos, etc.) will
# have no cover until admin uploads one manually.

DISCOGRAPHY = [
  {
    name: "Rotoscope",
    john_role: "Co-producer, writer, guitar, synth, bass, vocals, programming",
    description: "John's own project. Eight releases spanning two decades of writing and producing.",
    recordings: [
      { title: "Permanent Daylight", year: 2020, date: "2020-08-21", kind: "album",
        role: "Co-producer, writer, guitar, synth, bass, vocals, programming, et al" },
      { title: "Clean Lines EP", year: 2017, date: "2017-10-27", kind: "ep",
        role: "Co-producer, writer, guitar, synth, bass, vocals, programming, et al" },
      { title: "Vista Del Mar", year: 2007, date: "2007-07-01", kind: "album",
        role: "Writer, guitar, programming, keyboards, vocals, bass, additional engineering, co-producer" },
      { title: "All That's Left / Watershed", year: 2004, kind: "single",
        role: "Writer, guitar, vocals" },
      { title: "Drive / Fast Food / Time Realized", year: 2002, kind: "single",
        role: "Producer, engineer, co-writer, guitar, vocals, keyboards" },
      { title: "One Day / Watershed / Phone", year: 2000, kind: "single",
        role: "Writer, guitar, vocals, keyboards" }
    ]
  },
  {
    name: "Juniper Lane",
    john_role: "Guitar, keyboards, programming, additional engineering",
    description: "DC-area band; John contributed across studio records and the 2008 Verizon Center opener for Coldplay.",
    recordings: [
      { title: "Standing on the White Line", year: 2012, kind: "album",
        role: "Guitar, keyboards, programming, additional engineering" },
      { title: "Live at the Phone Booth", year: 2011, kind: "album",
        role: "Live performance recording (guitar, keyboards) of band opening for Coldplay at The Verizon Center in Washington DC (03 Aug 2008)" },
      { title: "Wake From Yourself", year: 2007, kind: "album",
        role: "Contributing musician",
        tracks: [
          { title: "Memento", role: "Keyboards and guitar" },
          { title: "Impact",  role: "Keyboards" },
          { title: "Coma",    role: "String section" }
        ] }
    ]
  },
  {
    name: "Boboroshi & Kynz",
    john_role: "Producer, mixer, engineer, synths, guitar",
    recordings: [
      { title: "Unbearable Bliss (Ambient) Single", year: 2010, kind: "single",
        role: "Producer, mixer, engineer, synths, guitar" },
      { title: "Unbearable Bliss", year: 2008, kind: "album",
        role: "Producer, mixer, engineer, synths, guitar, bass" }
    ]
  },
  {
    name: "Honor By August",
    recordings: [
      { title: "Found", year: 2009, kind: "album",
        role: "Hammond organ, co-arranging" },
      { title: "Happy Holidays", year: 2008, kind: "single",
        role: "Producer, engineer, mixer" }
    ]
  },
  {
    name: "Josh Garrels",
    recordings: [
      { title: "Chrysalis", year: 2019, date: "2019-08-09", kind: "album",
        role: "Guitar and synth" }
    ]
  },
  {
    name: "Bifrost Arts",
    recordings: [
      { title: "Lamentations", year: 2016, date: "2016-03-01", kind: "album",
        role: "Co-producer, synth, guitar, bass" }
    ]
  },
  {
    name: "Gramophonic",
    recordings: [
      { title: "The Red and the Black", year: 2015, kind: "album",
        role: "Mixer (6 tracks); additional production (6 tracks); guitar, keys, additional bass guitar" }
    ]
  },
  {
    name: "The Roman Spring",
    recordings: [
      { title: "Islands", year: 2015, kind: "remix",
        role: "Remix (as Rotoscope)" }
    ]
  },
  {
    name: "The Aurora Lovely",
    recordings: [
      { title: "Gone", year: 2013, kind: "single",
        role: "Guitar, keys, programming, co-mixer" }
    ]
  },
  {
    name: "Eden",
    description: "Independent film soundtrack.",
    recordings: [
      { title: "Eden (Soundtrack)", year: 2011, kind: "soundtrack",
        role: "Producer, synths, programming, mixer" }
    ]
  },
  {
    name: "The D.R.A.M.A. Kings",
    recordings: [
      { title: "Remixes", year: 2009, kind: "other",
        role: "Remixes",
        tracks: [
          { title: "Caught Up",       role: "Remix" },
          { title: "Turn It Around",  role: "Remix" }
        ] }
    ]
  },
  {
    name: "The Known Unknowns",
    recordings: [
      { title: "The Known Unknowns EP", year: 2008, kind: "ep",
        role: "Co-producer, co-engineer, co-mixer" }
    ]
  },
  {
    name: "Wes Charlton",
    recordings: [
      { title: "Demos", year: 2007, kind: "other",
        role: "Producer, engineer, and performer",
        tracks: [
          { title: "Meant To Be",      role: "Producer, engineer, performer" },
          { title: "World on Fire",    role: "Producer, engineer, performer" },
          { title: "Divided Highway",  role: "Producer, engineer, performer" }
        ] }
    ]
  },
  {
    name: "Tilae Linden",
    recordings: [
      { title: "Rotation", year: 1997, kind: "album",
        role: "Writer, guitar, vocals, mandolin" }
    ]
  },
  {
    name: "The Lindens",
    recordings: [
      { title: "I Ran Away", year: 1994, kind: "album",
        role: "Writer, guitar, vocals" }
    ]
  }
].freeze

DISCOGRAPHY.each_with_index do |data, position|
  artist = Music::Artist.find_or_initialize_by(name: data[:name])
  artist.assign_attributes(
    position: position,
    john_role: data[:john_role]
  )
  artist.description = data[:description] if data[:description].present? && artist.description.blank?
  artist.save!

  data[:recordings].each do |rec_data|
    recording = artist.recordings.find_or_initialize_by(title: rec_data[:title])
    recording.assign_attributes(
      release_year: rec_data[:year],
      release_date: rec_data[:date].presence,
      kind: rec_data[:kind],
      john_role_override: rec_data[:role]
    )
    recording.save!

    Array(rec_data[:tracks]).each do |track_data|
      track = recording.tracks.find_or_initialize_by(title: track_data[:title])
      track.assign_attributes(john_role: track_data[:role])
      track.save!
    end

    result = Music::CoverFetcher.call(recording)
    label = { attached: "cover ✓", enriched: "apple_music_url ✓", noop: "·", failed: "✗" }[result]
    puts "  #{label} #{recording.artist.name} - #{recording.title}"
  end
end

puts "Music seed complete: #{Music::Artist.count} artists, #{Music::Recording.count} recordings, #{Music::Track.count} tracks."
