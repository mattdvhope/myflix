Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end

    member do
      post 'highlight', to: 'videos#highlight'
    end
  end

  get '/home', to: 'videos#index'

  resources :categories, only: [:show]

end
