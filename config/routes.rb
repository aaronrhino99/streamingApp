Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }

  resources :songs, only: %i[index show create update] do
    get :stream, on: :member
  end
  resources :playlists, only: %i[index show create] do
    resources :songs, only: %i[create], controller: :playlist_songs
  end
  get "search", to: "search#index"

  if Rails.env.development?
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end
end
