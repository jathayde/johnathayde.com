# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

###############################################################################
# Initial launch will not include most admin/edit views, due to time
# constraints, so this is the seed file of joy and wonder. I forecast many db
# resets in the future leading up to launch.

###############################################################################
# APPEARANCE TYPES

AppearanceType.create!(id: 1, title: 'Conference')
AppearanceType.create!(id: 2, title: 'Podcast')
AppearanceType.create!(id: 3, title: 'Workshop')
AppearanceType.create!(id: 4, title: 'Meetup')
AppearanceType.create!(id: 5, title: 'Other')

###############################################################################
# TALKS

Talk.create!(
  id: 1,
  title: 'Dabble, Dabble, Toil & Kick Ass',
  subtitle: '',
  description: "Zen masters taught it. Isaac Newton knew it. Scott Adams writes about it. Now you can know it, too We're talking, of course, about the manifold benefits of being a n00b (at something). And, of course, about all the good stuff that happens post-n00bishness: the excellent side effects of being good at multiple things, even if they're not related - heck, *especially* if they're not related. So many of humanity's important discoveries, innovations and beautiful leaps of logic have been made by people whose brains were leveled up by the cross-fertilization of multiple interests and disciplines. Nano-thin specialization is out, a broad understanding of life, the universe, and everything is in. It's time to synergize, baby. So, reach outside your comfort zone, be a beginner again, and you'll be smarter, sexier, better at you job... even more valuable. With the wisdom of the ages (and a little bit from modern pundits), we'll talk about how, why, when, and where you can go about it. You won't regret it.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="4f70857b98186f0022033869" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 2,
  title: 'Curing DIV-itis with Semantic Markup, CSS, and Presenters',
  subtitle: '',
  description: "Modern web apps are built with all sorts of tools, but the basics of Semantic, Valid HTML and CSS are still the foundation. In this talk, we'll look at how to use semantic markup and CSS to build a responsive, accessible, and maintainable web app. We'll also look at how to use presenters to make your views more readable and easier to test.",
  speaker_deck_embed: ''
)

Talk.create!(
  id: 3,
  title: 'The Rails View: The Junk Drawer Grows Up',
  subtitle: '',
  description: "You like Ruby. You know how to write it and refactor it. Controllers and Models are Ruby: fantastic, superb! Views, on the other hand, while Ruby ? are also mixed with HTML, JavaScript (or CoffeeScript), and CSS (or SCSS). In this mixed environment it?s easy to drop your high code standards and turn the top of the Rails stack into a nasty, brittle mess just to get things done. How do you recover, or even better, avoid the trap in the first place? How can you get to the point where you treat your views like code you?re confident in?We'll cover 10 simple rules you can follow immediately to transform the way you write, think, and feel about Rails views. We'll also look at some cutting edge techniques with SCSS, SVG imagery, and more in some recent projects the speaker has been working on.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="4f7085d098186f07b5004e4f" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 4,
  title: 'UX Eye for the Javascript Guy/Gal',
  subtitle: '',
  description: "UX isn't just about the pretty. Learn solid techniques to improve your user's experience and make your apps awesome.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="8dd91af01431013124194623091db79e" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 5,
  title: 'The Timeless Way of Building',
  subtitle: '',
  description: "\"Design patterns\" is a common phrase that is often spoken in the course of design and development of web applications. But it's genesis is not from programming, but Architecture. They come from a trio of books in the 1970s by Christopher Alexander, the most famous of which is the middle book: \"A Pattern Language\". The issue arises that Pattern Languages, much like spoken languages, are most effective when the speaker is fluent. \n\nWe'll look at the origin of pattern languages (and later, pattern libraries) and why they can be dangerous and even detrimental tools in the hands of the inexperienced designer and developer. Through examples of bad grammar, poor idiomatic choices, and horrible experience flows (aka antipatterns), we'll explore \"the quality of a space that can't be named\" and see if we can create that in the products we create. We may even look at some architecture (buildings) as well. \n\nWhile this talk does show specific code and design examples, the concepts are high-level and Christopher Alexander\'s work has been applied to many different fields. ",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="c76a3eeddda4450a876bb3a7e5d14693" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 6,
  title: 'How They Work Better Together',
  subtitle: 'Lean UX, Agile Development, and User-Centered Design',
  description: "Design has often been cut off from the development side of the house, creating static images that are then handed off to developers to build. Invariably, this waterfall approach leads to unhappy designers and frustrated programmers, and often a product that misses the mark. Agile Development has solved many of the issues, but in many cases, designers still sit on the outside. \n\nWe'll look at integrating your design team (even if it's a team of one) into an agile development organization while still pushing user-centric design. We'll study successes and failures from both consultancies (InfoEther, Hyphenated People, Meticulous) and product companies both large and small (LivingSocial, CargoSense).",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="1e5aa9c0ae47013156964eab6e1d3af5" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 7,
  title: 'UX for Developers',
  subtitle: '',
  description: "The goal of this talk is to give developers five solid techniques and concepts that they can implement as soon as they return to work. We'll start with a very quick level set of what \"design\" is and why the standard \"designers hand off to developers\" workflow is a mess. We'll then move on to discussing problem analysis and definition, sketching/crazy eights/six-ups, prototyping, user testing, and finally components and living style guides.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="612670ca94cd40f3a29925a7fe212fa7" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 8,
  title: 'Building a UX Team',
  subtitle: 'Strategies for Hiring & Retaining Good Designers',
  description: "UX Teams are complex. They require a mix of skills and personalities that can be difficult to find and even more difficult to retain. We'll look at the various roles that make up a UX team and how to hire for them. We'll also look at how to retain your designers and keep them happy.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="3bc73b22204e410dbc59667e532f0b4d" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 9,
  title: 'Bring Lean UX to Your Product and Engineering Cycles',
  subtitle: '',
  description: "This Workshop will walk users through the tools and techniques for the high-level UX process on a project, equipping them with the tools to bring Lean UX to their own teams. We'll cover the basics of the Lean UX process, including how to define a problem, sketching, prototyping, user testing, and how to integrate UX into your Agile development process. We'll also cover how to build a UX team and how to hire and retain good designers.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="5cba37237b4440a98074dab316f2425c" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 10,
  title: 'Build Software Like Pixar Makes Movies',
  subtitle: '',
  description: "Pixar is a creative powerhouse. They're responsible for reinventing Disney animation, and it all comes down to creative process. But most people don't realize is that Pixar is a hardware and software company that made movies to figure out what they could do with their tools.\n\nIn this talk we'll look at Pixar's history, process, and how we can apply that to building our own products with intensive user research, constant refactoring, and infectious collaboration. Learn about the benefits of hiring varied discipline individuals and teaching them their jobs, with experience from similar programs at LivingSocial Engineering.",
  speaker_deck_embed: ''
)

Talk.create!(
  id: 11,
  title: 'Type is Design',
  subtitle: 'Fix Your UI with Better Typography and CSS',
  description: "The written word is the medium through which most information exchanges hands in the tools we build. Digital letterforms can help or hinder the ability for people to communicate and understand. We'll work through some typographic principles and then apply them to the web with HTML and CSS for implementation. We'll look at some of the newer OpenType features and touch on the future of digital type, variable fonts, and more.",
  speaker_deck_embed: ""
)

Talk.create!(
  id: 12,
  title: 'Building the LivingSocial Customer Support Tool',
  subtitle: '',
  description: "LivingSocial's Customer Support Tool is a case study in how a small product, ux, and front-end team was able to make major moves on the needle and the bottom line of the company.",
  speaker_deck_embed: '<script async class="speakerdeck-embed" data-id="602063738c134159a4589eb33523d914" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Talk.create!(
  id: 13,
  title: 'APIs Need Ux Too',
  subtitle: '',
  description: "We've all been there: Attempting to work with a textual interface to a product or service and the responses come back with no clear error, or what we might change to get a better response. The built-in help is non-existent. We end up banging our head against the keyboard and getting fed up. It doesn't have to be this way. UX is not only “the pretty” or how something looks, but it is in fact about how things work. We'll look at some good and bad API interfaces (and command line tools) and talk about the best practices we can implement in our own products to help our end users have a better experience.",
  speaker_deck_embed: ''
)

Talk.create!(
  id: 14,
  title: 'Design Systems from Zero to One',
  subtitle: '',
  description: "Starting a design system can be daunting, especially on a more extensive app or family of applications. How do you start, and then how do you implement the plan? What are the pitfalls of common approaches and off-the-shelf setups? We'll dive into how to start your team on the path of bringing a design system to your organization. We'll identify steps you can take today to move the ball forward, and finally, we'll discuss some of the pitfalls and concerns to watch for as you move towards a unified experience.",
  speaker_deck_embed: ''
)

###############################################################################
# APPEARANCES & RECORDINGS
# The Sandbox screening schedule and VH1 award for nancies.org
# not included here. Recordings are auto-id'd, and listed immediately
# after their appearance.

Appearance.create!(
  id: 1,
  event: 'South by Southwest (SXSW)',
  date: '2008-03-07',
  location: 'Austin, Texas, USA',
  who: 'John Athayde & Amy Hoy',
  what: 'presenting "Dabble, Dabble, Toil and Kick Ass"',
  url: 'https://sxsw2008.sched.com/event/10giqc4/career-rev-342-dabble-dabble-toil-and-kick-ass',
  talk_id: 1,
  appearance_type_id: 1
)

Appearance.create!(
  id: 2,
  event: 'RailsConf 2010',
  date: '2010-06-08',
  location: 'Baltimore, Maryland, USA',
  who: 'John Athayde',
  what: 'presenting "Curing DIV-itis with Semantic Markup, CSS, and Presenters"',
  url: 'http://en.oreilly.com/rails2010/',
  talk_id: 2,
  appearance_type_id: 1
)

Appearance.create!(
  id: 3,
  event: 'NovaRUG',
  date: '2010-06-29',
  location: 'Reston, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "Curing DIV-itis with Semantic Markup, CSS, and Presenters"',
  url: '',
  talk_id: 2,
  appearance_type_id: 4
)

Appearance.create!(
  id: 4,
  event: 'RailsConf 2011',
  date: '2011-03-17',
  location: 'Baltimore, Maryland, USA',
  who: 'John Athayde & Bruce Williams',
  what: '4 hour workshop session on The Rails View',
  url: '',
  appearance_type_id: 3
)

Appearance.create!(
  id: 5,
  event: 'RubyNation 2012',
  date: '2012-03-24',
  location: 'Reston, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "The Rails View: The Junk Drawer Grows Up"',
  url: 'http://www.rubynation.org',
  talk_id: 3,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="4f7085d098186f07b5004e4f" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'The Rails View: The Junk Drawer Grows Up',
  url: 'https://www.confreaks.tv/videos/rubynation2012-the-rails-view-the-junk-drawer-grows-up',
  appearance_id: 5,
  recorded_on: '2012-03-24',
  talk_id: 3
)

Appearance.create!(
  id: 6,
  event: 'Scottish Ruby Conference',
  date: '2012-06-29',
  location: 'Edinburgh, Scotland, UK',
  who: 'John Athayde & Bruce Williams',
  what: 'presenting on The Rails View',
  url: 'http://www.scottishrubyconference.com',
  talk_id: 3,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="4fed98c7bf9228001f02459f" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'The Rails View: The Junk Drawer Grows Up',
  url: 'https://vimeo.com/55732690',
  appearance_id: 6,
  recorded_on: '2012-06-29',
  talk_id: 3
)

Appearance.create!(
  id: 7,
  event: 'NOVA Web Development Group',
  date: '2013-04-15',
  location: 'McLean, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "The Rails View: The Junk Drawer Grows Up',
  url: 'http://www.meetup.com/NoVA-Web-Develoment-User-Group/events/111119022/',
  talk_id: 3,
  appearance_type_id: 4
)

Appearance.create!(
  id: 8,
  event: 'NationJS 2013',
  date: '2013-10-04',
  location: 'Silver Spring, Maryland, USA',
  who: 'John Athayde',
  what: 'presenting "UX Eye for the JavaScript Guy/Gal"',
  url: 'http://www.nationjs.com',
  talk_id: 4,
  appearance_type_id: 1
  # speaker_deck_override: '<script async class="speakerdeck-embed" data-id="8dd91af01431013124194623091db79e" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 9,
  event: 'SassConf',
  date: '2013-10-13',
  location: 'Manhattan, New York, USA',
  who: 'John Athayde, Elyse Holladay, Rachel Ober, and Pam Selle',
  what: 'moderating a panel on "Custom Frameworks and Styleguides"',
  url: 'http://www.sassconf.com',
  appearance_type_id: 1
)

Recording.create!(
  title: 'Custom Framework/Styleguide Panel Part 1',
  url: 'https://www.youtube.com/watch?v=jeQm2Wrdlpc',
  appearance_id: 9,
  recorded_on: '2013-10-13'
)

Recording.create!(
  title: 'Custom Framework/Styleguide Panel Part 2',
  url: 'https://www.youtube.com/watch?v=k7gv56WYJKo',
  appearance_id: 9,
  recorded_on: '2013-10-13'
)

Appearance.create!(
  id: 10,
  event: 'MountainWest RubyConf 2014',
  date: '2014-03-20',
  location: 'Salt Lake City, Utah, USA',
  who: 'John Athayde',
  what: 'presenting "The Timeless Way of Building"',
  url: '',
  talk_id: 5,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="b0d5ebb09362013128a74261e6fe4add" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'The Timeless Way of Building',
  url: 'https://www.youtube.com/watch?v=DJJbIjlLmLM',
  recorded_on: '2014-03-20',
  talk_id: 5,
  appearance_id: 10
)

Appearance.create!(
  id: 11,
  event: 'RailsConf 2014',
  date: '2014-04-22',
  location: 'Chicago, Illinois, USA',
  who: 'John Athayde',
  what: 'presenting "How They Work Better Together: Lean UX, Agile Development, and User-Centered Design"',
  url: 'http://www.railsconf.com/',
  talk_id: 6,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="1e5aa9c0ae47013156964eab6e1d3af5" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'How They Work Better Together: Lean UX, Agile Development, and User-Centered Design',
  url: 'https://www.youtube.com/watch?v=zdwnogUMtc4&list=PLE7tQUdRKcyZ5jfnbS_osIoWzK_FrwKz5&index=46',
  recorded_on: '2014-04-22',
  talk_id: 6,
  appearance_id: 11
)

Appearance.create!(
  id: 12,
  event: 'RevolutionConf 2016',
  date: '2016-05-13',
  location: 'Virginia Beach, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "How They Work Better Together: Lean UX, Agile Development, and User-Centered Design"',
  url: '',
  talk_id: 6,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="1a025cfb9a6141738f15548a2301b4d6" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 13,
  event: 'RailsConf 2016',
  date: '2016-05-05',
  location: 'Kansas City, Missouri, USA',
  who: 'John Athayde',
  what: 'leading workshop "Bring Lean UX to Your Product and Engineering Cycles"',
  url: 'http://www.railsconf.com/',
  talk_id: 9,
  appearance_type_id: 1
)

Appearance.create!(
  id: 14,
  event: 'RevolutionConf 2017',
  date: '2017-06-01',
  location: 'Virginia Beach, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "The Timeless Way of Building"',
  url: 'http://www.revolutionconf.com/',
  talk_id: 5,
  appearance_type_id: 1
  # speaker_deck_override: '<script async class="speakerdeck-embed" data-id="c76a3eeddda4450a876bb3a7e5d14693" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'Chatting with Kevin Griffin about RevConf 2017',
  url: 'https://www.youtube.com/watch?v=BrT2zEwLCp4',
  recorded_on: '2017-04-06',
  appearance_id: 14
)

Appearance.create!(
  id: 15,
  event: 'RubyNation 2013',
  date: '2013-06-14',
  location: 'Silver Spring, Maryland, USA',
  who: 'John Athayde',
  what: 'presenting "The Timeless Way of Building"',
  url: '',
  talk_id: 5,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="5c0a4690b8210130b40c022eac0b5e7d" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 16,
  event: 'RevolutionConf 2018',
  date: '2018-05-17',
  location: 'Virgina Beach, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "Bring Lean UX to Your Product and Engineering Cycles"',
  url: 'http://www.revolutionconf.com/',
  talk_id: 7,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="4085e1f3a3f74639a93a6a7324d3509e" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 17,
  event: 'RVA.js',
  date: '2018-11-02',
  location: 'Richmond, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "UX for Developers"',
  url: 'https://www.rvajavascript.com/',
  talk_id: 7,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="612670ca94cd40f3a29925a7fe212fa7" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'UX for Developers',
  url: 'https://www.conferencecast.tv/talk-26728-rva-javascript-conf-2018-ux-for-developers-by-john-athayde',
  recorded_on: '2018-11-02',
  talk_id: 7,
  appearance_id: 17
)

Appearance.create!(
  id: 18,
  event: 'Frontrunners React!',
  date: '2019-12-06',
  location: 'Washington, DC, USA',
  who: 'John Athayde',
  what: 'presenting "Build Software Like Pixar Makes Movies"',
  url: '',
  talk_id: 10,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="432a05ee3d324297b6c6522660cb0833" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'Build Software Like Pixar Makes Movies',
  url: 'https://www.conferencecast.tv/talk-25477-build-software-like-pixar-makes-movies-by-john-athayde-nationjs-frontrunners-react-2019#.talkPage-header',
  recorded_on: '2019-12-06',
  talk_id: 10,
  appearance_id: 18
)

Appearance.create!(
  id: 19,
  event: 'RailsConf 2021',
  date: '2021-04-13',
  location: 'Virtual',
  who: 'John Athayde',
  what: 'presenting "Type is Design"',
  url: '',
  talk_id: 1,
  appearance_type_id: 1
)

Recording.create!(
  title: 'Type is Design',
  url: 'https://www.conferencecast.tv/talk-44520-type-is-designfix-your-ui-with-better-typography-and-css-john-athayde',
  recorded_on: '2021-04-13',
  talk_id: 11,
  appearance_id: 19
)

Appearance.create!(
  id: 20,
  event: 'NoVA Web Development User Group',
  date: '2013-04-15',
  location: 'Herndon, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "The Rails View: The Junk Drawer Grows Up"',
  url: '',
  talk_id: 3,
  appearance_type_id: 4
)

Recording.create!(
  title: 'The Rails View: The Junk Drawer Grows Up',
  url: 'https://www.youtube.com/watch?v=vHfDegpZHRs',
  recorded_on: '2013-04-15',
  talk_id: 3,
  appearance_id: 20
)

Appearance.create!(
  id: 21,
  event: 'RVA.js',
  date: '2019-11-07',
  location: 'Richmond, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "Build Software Like Pixar Makes Movies"',
  url: '',
  talk_id: 10,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="c81deb8314cf4ee1a7e29e145b707a93" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'Build Software Like Pixar Makes Movies',
  url: 'https://www.youtube.com/watch?v=rMzTpyTIi-0',
  recorded_on: '2019-11-07',
  talk_id: 10,
  appearance_id: 21
)

Appearance.create!(
  id: 22,
  event: 'Norfolk757rb',
  date: '2013-08-09',
  location: 'Norfolk, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "The Timeless Way of Building"',
  url: '',
  talk_id: 5,
  appearance_type_id: 4
)

Recording.create!(
  title: 'The Timeless Way of Building',
  url: 'https://www.youtube.com/watch?v=3AltRFXviK4',
  recorded_on: '2013-08-09',
  talk_id: 5,
  appearance_id: 22
)

Appearance.create!(
  id: 23,
  event: 'UX Strategies Summit 2015',
  date: '2015-06-10',
  location: 'San Francisco, California, USA',
  who: 'John Athayde',
  what: 'presenting "Building a UX Team"',
  url: '',
  talk_id: 8,
  appearance_type_id: 1
)

Appearance.create!(
  id: 24,
  event: 'EvolveUX 2016',
  date: '2016-06-15',
  location: 'San Francisco, California, USA',
  who: 'John Athayde',
  what: 'presenting "Building the LivingSocial Customer Support Tool"',
  url: '',
  talk_id: 12,
  appearance_type_id: 1
  # speaker_deck_override: '<script async class="speakerdeck-embed" data-id="602063738c134159a4589eb33523d914" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 25,
  event: 'NOVA Code Camp 2020',
  date: '2020-09-26',
  location: 'Virtual',
  who: 'John Athayde',
  what: 'presenting "UX for Developers"',
  url: '',
  talk_id: 7,
  appearance_type_id: 1,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="a78144beeecb4a26834d82a2c67352f8" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>'
)

Recording.create!(
  title: 'UX for Developers',
  url: 'https://www.youtube.com/watch?v=eK2s5UklZi8&list=PLXn1Ow3sQMtKSt1vMy9Td_dqGUnGsfjg4&index=19',
  recorded_on: '2020-09-26',
  talk_id: 7,
  appearance_id: 25
)

Appearance.create!(
  id: 26,
  event: 'RevolutionConf 2019',
  date: '2019-06-07',
  location: 'Virginia Beach, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "Build Software Like Pixar Makes Movies"',
  url: '',
  talk_id: 10,
  appearance_type_id: 1
)

Appearance.create!(
  id: 27,
  event: 'Code With Jason Podcast #89',
  date: '2021-03-25',
  location: 'Online',
  who: 'John Athayde & Jason Swett',
  what: 'discussing "Design Tips for Programmers"',
  url: 'https://www.codewithjason.com/podcast/9478226-089-design-tips-for-programmers-with-john-athayde-vp-of-design-at-powerfleet/',
  appearance_type_id: 2
)

Recording.create!(
  title: 'Design Tips for Programmers',
  url: 'https://www.buzzsprout.com/1878319/9478226-089-design-tips-for-programmers-with-john-athayde-vp-of-design-at-powerfleet.mp3',
  recorded_on: '2021-03-25',
  appearance_id: 27
)

Appearance.create!(
  id: 28,
  event: 'Secret Sonics Podcast',
  date: '2020-06-09',
  location: 'Online',
  who: 'John Athayde & Ben Wallick',
  what: 'discussing the Rotoscope record and audio production process',
  url: 'https://www.spreaker.com/user/benwallick/secret-sonics-051-john-athayde',
  appearance_type_id: 2
)

Recording.create!(
  title: 'Secret Sonics Podcast',
  url: 'https://api.spreaker.com/download/episode/32226500/secret_sonics_051_john_athayde.mp3?dl=true',
  recorded_on: '2020-06-09',
  appearance_id: 28
)

Appearance.create!(
  id: 29,
  event: 'Charlotte Ruby',
  date: '2012-10-03',
  location: 'Charlotte, North Carolina, USA',
  who: 'John Athayde',
  what: 'presenting "The Rails View: The Junk Drawer Grows Up"',
  url: '',
  talk_id: 3,
  appearance_type_id: 4
)

Appearance.create!(
  id: 30,
  event: 'Triangle.rb',
  date: '2013-01-08',
  location: 'Raleigh, North Carolina, USA',
  who: 'John Athayde',
  what: 'presenting "The Rails View: The Junk Drawer Grows Up"',
  url: 'http://www.meetup.com/raleighrb/events/96974032/',
  talk_id: 3,
  appearance_type_id: 4,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="c4d3cb803c420130e7b722000a1e877c" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 31,
  event: 'NYC.rb',
  date: '2012-11-13',
  location: 'New York, New York, USA',
  who: 'John Athayde',
  what: 'presenting "The Rails View: The Junk Drawer Grows Up"',
  url: '',
  talk_id: 3,
  appearance_type_id: 4,
  speaker_deck_override: '<script async class="speakerdeck-embed" data-id="a1705be010b701303464123138132f69" data-ratio="1.2994923857868" src="//speakerdeck.com/assets/embed.js"></script>'
)

Appearance.create!(
  id: 32,
  event: 'The Swift Kick Show 2019',
  date: '2019-10-16',
  location: 'Online',
  who: 'John Athayde & Kevin Griffin',
  what: 'discussing "Build Software Like Pixar Makes Movies"',
  url: '',
  appearance_type_id: 2,
  talk_id: 10
)

Recording.create!(
  title: 'Build Software Like Pixar Makes Movies',
  url: 'https://www.youtube.com/watch?v=CqvfTmxlmJk',
  recorded_on: '2019-10-16',
  appearance_id: 32,
  talk_id: 10
)

Appearance.create!(
  id: 33,
  event: "RVAJS 2022",
  date: '2022-11-17',
  location: 'Science Museum of Virginia; Richmond, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "APIs Need UX Too"',
  url: 'https://rvatech.com/rvatech-events/rvajs/',
  appearance_type_id: 1,
  talk_id: 13
)

Appearance.create!(
  id: 34,
  event: "Ruby Remote Conf 2015",
  date: '2015-09-01',
  location: 'Online',
  who: 'John Athayde',
  what: 'presenting "How They Work Better Together: Lean UX, Agile Development, and User-Centered Design"',
  url: 'https://rubyremoteconf.com/',
  appearance_type_id: 1,
  talk_id: 6
)

Recording.create!(
  title: 'How They Work Better Together: Lean UX, Agile Development, and User-Centered Design',
  url: 'https://www.youtube.com/watch?v=1umoY357VZg',
  recorded_on: '2015-09-01',
  appearance_id: 34,
  talk_id: 6
)

Appearance.create!(
  id: 35,
  event: "Frontrunners 2022",
  date: '2023-03-10',
  location: 'GMU\'s Van Metre Hall, Arlington, Virginia, USA',
  who: 'John Athayde',
  what: 'presenting "Design Systems from Zero to One"',
  url: 'https://frontrunners.tech',
  appearance_type_id: 1,
  talk_id: 14
)

Appearance.create!(
  id: 36,
  event: "Product Thinking Podcast Ep. 91",
  date: '2022-10-26',
  location: 'Online',
  who: 'John Athayde & Melissa Perri',
  what: 'discussing Investing in Internal Tools & Design Systems',
  url: 'https://produxlabs.com/product-thinking-blog/episode-91-john-athayde',
  appearance_type_id: 2,
  talk_id: ''
)


# Appearance.create!(
#   id: 1,
#   event: '',
#   date: '',
#   location: '',
#   who: '',
#   what: '',
#   url: '',
#   talk_id: 1,
#   appearance_type_id: 1
# )

# UX Strategies Summit 2014 - UX talk
# Scouting Hot FInds Podcast/Patchvault
# LFTN Podcast?
