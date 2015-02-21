Tournaments::Application.routes.draw do
  root 'leagues#index'

  resources :games

  resources :teams

  resources :leagues
end
