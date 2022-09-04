# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#placeholder'

  get '/home', to: 'pages#index'
  get '/contact', to: 'contact#new'
  get '/resume', to: 'pages#resume'
end
