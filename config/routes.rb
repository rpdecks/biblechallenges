Biblechallenge::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users, controllers: { registrations: "users/registrations" }

  resource :profile, only: [:update, :edit]

  namespace :creator do
    resources :challenges
  end

  # member is a namespace for users in a challenge
  namespace :member do
    resources :challenges, only: [:index, :show] do
      resources :groups, only: [:new, :create, :index]
      resources :memberships, only: [:create] 
    end
    resources :groups, except: [:new, :create, :index] do
      member do
        post 'join'
        post 'leave'
      end
    end
    resources :memberships, only: [:update, :index, :show, :destroy, :edit] do
      member do
        get 'unsubscribe'
      end
    end
  end

  resources :badges, only: [:index, :show]

  resources :readings, only: [:show, :edit, :update] do
    resources :comments, only: [:create, :destroy], controller: 'readings/comments' 
  end

  resources :comments, only: [] do
    resources :comments, only: [:create], controller: "comments/comments"
  end

  # more restful reading logging
  resources :membership_readings, only: [:create, :destroy] do
    member do
      get 'confirmation'
    end
  end

  get '/log_reading/' => 'membership_readings#create', as: 'log_reading'

  resources :challenges, only: [:index, :show], controller: 'challenges'
  root to: 'challenges#index'

end
