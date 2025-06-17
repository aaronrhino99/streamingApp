
 Rails.application.routes.draw do
 # All routes default to JSON format
  scope defaults: { format: :json } do
     # Devise authentication
     devise_for :users, controllers: {
       sessions:      'users/sessions',
       registrations: 'users/registrations'
     }

    resources :songs, only: %i[index show create update] do
      get :stream, on: :member
      post :download, on: :member
    end
    # Song CRUD plus streaming & download endpoints
    resources :songs, only: %i[index show create update] do
      member do
        get  :stream   # GET /songs/:id/stream
        post :download # POST /songs/:id/download
      end
    end

    resources :playlists, only: %i[index show create] do
      resources :songs, only: %i[create], controller: :playlist_songs
    end
    # Playlist CRUD and adding songs to a playlist
    resources :playlists, only: %i[index show create] do
      resources :songs,
                only:      %i[create],
                controller: 'playlist_songs'
    end

     # Public YouTube search
    get 'search', to: 'search#index'
  end

   # Sidekiq Web UI in development
  if Rails.env.development?
   require 'sidekiq/web'
   mount Sidekiq::Web => '/sidekiq'
  end

   # Silence favicon requests
 get '/favicon.ico', to: ->(_) { [204, {}, []] }
end
