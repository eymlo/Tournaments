Tournaments::Application.routes.draw do
  root 'leagues#index'

  resources :games

  resources :teams

  resources :leagues do
    member do
      get :standings
      put :start
      get :calendar
    end
  end
end
