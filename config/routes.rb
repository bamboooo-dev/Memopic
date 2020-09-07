Rails.application.routes.draw do

  root 'static_pages#top'
  get '/howto', to: 'static_pages#howto'

  resources :albums, param: :album_hash do
    member do
      get '/export', to: 'albums#export'
    end
  end

  get '/health', to: 'health#health'
  post '/callback', to: 'linebot#callback'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get "user/:id", :to => "users/registrations#detail"
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end

  resources :playlists, only: [:create, :destroy]
  resources :comments, only: [:index, :create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :user_albums, only: [:create]

  # API
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :albums, param: :album_hash
      resources :favorites, only: [:create, :destroy]
      resources :user_albums, only: [:create]
    end
  end
end
