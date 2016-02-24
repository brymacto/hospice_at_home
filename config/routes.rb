Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get 'static_pages/home'

  root 'clients#index'

  resources :clients do
    resources :matches, only: [:show, :index]
  end

  resources :volunteers do
    resources :matches, only: [:show, :index]
    member do
      post 'add_availabilities'
      patch 'add_specialty'
      get 'remove_specialty'
    end
  end

  get 'matches/explorer' => 'matches#explorer', as: :matches_explorer
  resources :match_explorations, only: 'create'
  resources :matches
  resources :match_requests, only: [:update]
  resources :match_proposals do
    resources :match_requests
  end
  resources :availabilities
  resources :specialties

end
