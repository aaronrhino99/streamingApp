Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'search/youtube_search', to: 'search#youtube_search'
      get 'search/video_details', to: 'search#video_details'
      get 'search', to: 'search#index'  # ← this line adds /api/v1/search

      resources :songs, only: [:index, :create]
    end
  end
end


