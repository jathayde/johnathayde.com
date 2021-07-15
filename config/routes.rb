Rails.application.routes.draw do
  root to: "pages#index"

  get 'resume', to: 'pages#resume'
end
