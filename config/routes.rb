Rails.application.routes.draw do

  root 'home#show'

  resource :home, controller: :home, only: [:show] do
    post :search_places, on: :collection
  end

  scope :geolocations, controller: :geolocations, as: :geolocations do
    get :pharmacies
    get :wet_and_dry_wastes
    get :hazardous_wastes
    get :bulky_wastes
    get :packaging_wastes
  end

  devise_for :admin

  namespace :service do
    root 'dashboard#show'
    resource :admin, controller: :admin, only: [:edit, :update]
    resource :dashboard, controller: :dashboard, only: :show
    resources :pharmacies,         only: [:new, :create]
    resources :wet_and_dry_wastes, only: [:new, :create]
    resources :hazardous_wastes,   only: [:new, :create]
    resources :bulky_wastes,       only: [:new, :create]
    resources :packaging_wastes,   only: [:new, :create]
  end
  #devise_for :admin, path: "auth", path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
end
