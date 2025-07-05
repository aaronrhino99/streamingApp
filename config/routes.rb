Rails.application.routes.draw do
  # Health-check for uptime monitoring
  # get 'health', to: 'application#health_check'

  # API routes, versioned under /api/v1
  namespace :api do
    namespace :v1 do
      # Search YouTube videos via GET /api/v1/search?q=...
      get 'search', to: 'search#index'

      # Authentication
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      delete 'auth/logout', to: 'auth#logout'
      get 'auth/profile', to: 'auth#profile'

      # Songs resource (index, show, create, update, destroy)
      resources :songs do
        # Optionally add custom member routes if you need them
        # get    :stream,   on: :member
        # post   :download, on: :member
      end

      # Playlists resource
      resources :playlists do
        # Nested creation of playlist_songs
        resources :songs, only: [:create], controller: 'playlist_songs'
      end
    end
  end
end