# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#placeholder'

  get '/home', to: 'pages#index'
  get 'contact', to: 'contact#new', as: 'contact'
  post 'contact', to: 'contact#create'
  get '/resume', to: 'pages#resume'

  resources :speaking, only: %i[index] do
    resources :appearances do
      resources :recordings
    end
    resources :talks
  end
end
