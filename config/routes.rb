Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: 'videos#search'
    end
  end

  get '/home', to: 'videos#index'

  resources :categories, only: [:show]

end
