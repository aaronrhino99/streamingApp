Rails.application.routes.draw do
  scope defaults: { format: :json } do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    resources :songs, only: %i[index show create update] do
      get :stream, on: :member
      post :download, on: :member
    end

    resources :playlists, only: %i[index show create] do
      resources :songs, only: %i[create], controller: :playlist_songs
    end

    get 'search', to: 'search#index'
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/favicon.ico', to: ->(_) { [204, {}, []] }
end