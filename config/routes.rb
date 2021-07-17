Rails.application.routes.draw do
  root to: "pages#index"

  get "contact", to: "contact#new"
  get "resume", to: "pages#resume"
end
