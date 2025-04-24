Rails.application.routes.draw do
  # Root route
  root "pages#home"
  
  # Devise routes
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  require 'sidekiq/web'

  
  # Sidekiq monitoring interface (admin only)
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  # Static pages
  get "pages/home"
  get "pages/about"
  
  # API routes
  namespace :api do
    namespace :v1 do
      get "youtube_search/search"
      get "youtube_search/show"
      resources :songs
      resources :playlists
      get 'youtube/search', to: 'youtube_search#search'
      get 'youtube/videos/:id', to: 'youtube_search#show'
    end
  end
  
  # Main application routes
  # Replace individual route declarations with resources
  resources :playlists
  resources :songs do
    collection do
      get :search  # This creates /songs/search
    end
  end
  

end