Rails.application.routes.draw do

  devise_for :users
  root 'pages#home'
  get 'pages/about', as: :about

  resources :cards
  resources :lists
end
