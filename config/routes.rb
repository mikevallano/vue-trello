Rails.application.routes.draw do

  devise_for :users
  root 'pages#home'
  get 'pages/about', as: :about

  resources :cards do
    member do
      patch :move
    end
  end
  resources :lists do
    member do
      patch :move
    end
  end
end
