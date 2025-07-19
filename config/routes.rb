Rails.application.routes.draw do
  # API routes, versioned under /api/v1
  namespace :api, defaults: {format: :json }do
    namespace :v1 do
      # GET /api/v1/search?q=…
      get    'search',        to: 'search#index'

      # Auth
      post   'auth/register', to: 'auth#register'
      post   'auth/login',    to: 'auth#login'
      delete 'auth/logout',   to: 'auth#logout'
      get    'auth/profile',  to: 'auth#profile'

      # Songs resource, plus GET /api/v1/songs/:id/stream
      resources :songs do
        get :stream, on: :member
      end

      # Playlists
      resources :playlists do
        resources :songs, only: [:create], controller: 'playlist_songs'
      end
    end
  end
end