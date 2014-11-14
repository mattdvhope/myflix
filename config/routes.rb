Myflix::Application.routes.draw do

  root to: "pages#front" # Standard procedure to serve static pages: Make a 'pages' controller & have each of its pages (i.e., 'front') as an action for the 'pages' controller.
  get 'home', to: 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create] # We need the :create to have access to the `admin_videos_path' method for http://localhost:3000/admin/videos/new
  end

  get 'relationships/index'
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'

  get 'my_queue', to: 'queue_items#index'

  get 'ui(/:action)', controller: 'ui'
  get 'register', to: "users#new" # Unlike the registration below (get 'register/:token', etc...), this registration was not in response to an invitation.
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token' # ':token' will be a request parameter. When we do register_with_token_url(@invitation) and pass in a parameter, it will take the token value and become part of the url.
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"

  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]

  get 'forgot_password', to: 'forgot_passwords#new' # The only reason we have a 'forgot_passwords' controller is that we have a place to hold these three actions: 'new', 'create' & 'confirm'
  resources :forgot_passwords, only: [:create] # a 'virtual' resource; no model for this; we don't want to jam the 'new' and 'create' action into the sessions controller; this is a common rails practice to separate actions like these; if we'd jammed these into the 'sessions' controller, it would be to confusing and would likely get out of control.
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :password_resets, only: [:show, :create] # The 'show' action always expects a user id.  That will be '@user.token' here from 'send_forgot_password.html.haml'
  get 'expired_token', to: 'pages#expired_link'

  resources :invitations, only: [:new, :create]

  mount StripeEvent::Engine, at: '/stripe_events' # for webhooks with gem 'stripe_event' ; Make sure you use the ', at:' rather than the hash rocket which was old syntax that now does not work.

end
