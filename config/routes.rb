# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#placeholder'

  get '/home', to: 'pages#index'
  get '/contact', to: 'contact#new', as: 'contact'
  post '/contact', to: 'contact#create'
  get '/resume', to: 'pages#resume'

  get '/music', to: 'music#index'

  get '/speaking', to: 'speaking#index'
  namespace :speaking do
    resources :appearances do
      resources :recordings
    end
    resources :talks
  end

  get '/work', to: 'work#index'
  get '/work/livingsocial-csr', to: 'work#livingsocial_csr'
  get '/work/navanti-pulse', to: 'work#navanti_pulse'
  get '/work/procore', to: 'work#procore'
  get '/work/powerfleet-chassis', to: 'work#powerfleet_chassis'
end
