Myflix::Application.routes.draw do

  get 'relationships/index'

  root to: "pages#front" # Standard procedure to serve static pages: Make a 'pages' controller & have each of its pages (i.e., 'front') as an action for the 'pages' controller.
  get 'home', to: 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'my_queue', to: 'queue_items#index'

  get 'ui(/:action)', controller: 'ui'
  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"

  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]

  get 'forgot_password', to: 'forgot_passwords#new' # The only reason we have a 'forgot_passwords' controller is that we have a place to hold these three actions: 'new', 'create' & 'confirm'
  resources :forgot_passwords, only: [:create] # a 'virtual' resource; no model for this; we don't want to jam the 'new' and 'create' action into the sessions controller; this is a common rails practice to separate actions like these; if we'd jammed these into the 'sessions' controller, it would be to confusing and would likely get out of control.
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create] # The 'show' action always expects a user id.  That will be '@user.token' here from 'send_forgot_password.html.haml'
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new]
end
