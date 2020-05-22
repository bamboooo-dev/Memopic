Rails.application.routes.draw do

  root 'albums#index'

  resources :albums, only: [:index, :create, :show, :destroy], param: :album_hash
  get 'static_pages/home'
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

  resources :favorites, only: [:create, :destroy]
  resources :user_albums, only: [:create]
end
