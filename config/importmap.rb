# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.2/modular/sortable.esm.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'process', to: 'https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.21/nodelibs/browser/process-production.js'
pin 'stimulus-textarea-autogrow', to: 'https://ga.jspm.io/npm:stimulus-textarea-autogrow@4.0.0/dist/stimulus-textarea-autogrow.es.js'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
