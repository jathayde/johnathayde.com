# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#placeholder'

  get '/home', to: 'pages#index'
  get '/contact', to: 'contact#new', as: 'contact'
  post '/contact', to: 'contact#create'
  get '/resume', to: 'pages#resume'

  get '/music', to: 'music#index'

  # ---- Public read-only ----
  get '/speaking', to: 'speaking#index'
  namespace :speaking do
    resources :appearances, only: %i[index show]
    resources :talks,       only: %i[index show]
  end

  resources :articles, only: %i[index show]

  # ---- Admin CRUD (HTTP basic auth, admin layout) ----
  get '/admin', to: 'admin#index', as: 'admin'
  namespace :admin do
    resources :appearance_types
    resources :appearances do
      resources :recordings
    end
    resources :talks
    resources :articles
  end

  get '/work', to: 'work#index'
  get '/work/livingsocial-csr', to: 'work#livingsocial_csr'
  get '/work/navanti-pulse', to: 'work#navanti_pulse'
  get '/work/procore', to: 'work#procore'
  get '/work/powerfleet-chassis', to: 'work#powerfleet_chassis'
end
