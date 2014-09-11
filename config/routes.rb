V3::Application.routes.draw do
  root to: 'generals#main'

  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  get 'users/new', to: 'users#new'
  post 'users/create', to: 'users#create', as: 'users'
  get 'users/reset_password/:token', to: 'users#reset_password', as: 'reset_password'
  put 'users/update_password/:token', to: 'users#update_password', as: 'update_password'
  get 'profile', to: 'users#show'

  resources :feeds, only: [:new, :index]

  get 'home', to: 'generals#home'
  get 'policies', to: 'generals#policies'
  get 'about', to: 'generals#about'
  get 'support', to: 'generals#support'
  get 'feedback', to: 'generals#feedback'
  post 'send_feedback', to: 'generals#send_feedback', as: 'feedbacks'

  namespace :api do
    resources :feeds, only: [:create, :index]
    get 'feeds/refresh', to: 'feeds#refresh'
    get 'feeds/browse', to: 'feeds#browse'
    get 'feeds/home', to: 'feeds#home'
    post 'feeds/search', to: 'feeds#search'

    resources :user_feeds, only: [:create, :destroy, :update]
    put 'user_feeds_all', to: 'user_feeds#update_all'

    resources :user_feed_entries, only: [:create, :update]

    put 'users/update_pass', to: 'users#update_password'
    post 'users/forgot_pass', to: 'users#forgot_password'
    get 'users/themes', to: 'users#themes'
    get 'users/layouts', to: 'users#layouts'
    put 'users/update_theme', to: 'users#update_theme'
    put 'users/update_layout', to: 'users#update_layout'
    get 'users/welcome', to: 'users#get_welcome'
    put 'users/next_welcome', to: 'users#update_welcome'
  end
end
