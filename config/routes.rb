# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#placeholder'

  get '/home', to: 'pages#index'
  get '/contact', to: 'contact#new', as: 'contact'
  post '/contact', to: 'contact#create'
  get '/resume', to: 'pages#resume'

  get '/music', to: 'music#index'
  get '/music/timeline', to: 'music#timeline', as: 'music_timeline'
  namespace :music do
    resources :artists, only: %i[show], path: '', param: :id
  end

  # ---- Public read-only ----
  get '/speaking', to: 'speaking#index'
  namespace :speaking do
    resources :appearances, only: %i[index show]
    resources :talks,       only: %i[index show]
  end

  # ---- Blog ----
  # Literal segments (category/tag/feed) must stay above the :slug wildcard.
  get '/blog',                to: 'blog#index',    as: 'blog'
  get '/blog/feed',           to: 'blog#feed',     as: 'blog_feed', defaults: { format: 'atom' }
  get '/blog/category/:slug', to: 'blog#category', as: 'blog_category'
  get '/blog/tag/:tag',       to: 'blog#tag',      as: 'blog_tag'
  get '/blog/:slug',          to: 'blog#show',     as: 'blog_post'

  # Legacy article URLs
  get '/articles',       to: redirect('/blog', status: 301)
  get '/articles/:slug', to: redirect('/blog/%{slug}', status: 301)

  # LLM-readable index of blog posts (llmstxt.org convention)
  get '/llms.txt', to: 'blog#llms'

  # ---- Admin CRUD (HTTP basic auth, admin layout) ----
  get '/admin', to: 'admin#index', as: 'admin'
  namespace :admin do
    resources :appearance_types
    resources :appearances do
      resources :recordings
    end
    resources :talks do
      member { post :fetch_cover }
    end
    resources :articles
    resources :categories, except: %i[show]

    namespace :music do
      resources :artists do
        collection { patch :reorder }
        resources :recordings, only: %i[new create]
        resources :videos,     only: %i[new create]
      end
      resources :recordings, except: %i[new create] do
        member { post :fetch_cover }
        resources :tracks, except: %i[show]
      end
      resources :videos, except: %i[show new create]
    end
  end

  get '/work', to: 'work#index'
  get '/work/livingsocial-csr', to: 'work#livingsocial_csr'
  get '/work/navanti-pulse', to: 'work#navanti_pulse'
  get '/work/procore', to: 'work#procore'
  get '/work/powerfleet-chassis', to: 'work#powerfleet_chassis'
end
