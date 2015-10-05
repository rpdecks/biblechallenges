Biblechallenge::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  get '/test_exception_notifier', to: 'application#test_exception_notifier'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    match '/users/finish_signup' => 'users/registrations#finish_signup',
      via: [:get, :patch],
      :as => :finish_signup
  end

  resource :user, only: [:edit, :update]

  get 'user/:id/remove_avatar', to: 'users#remove_avatar', as: 'remove_user_avatar'

  namespace :creator do
    resources :challenges do
      resources :groups, only: [:new, :create, :edit]
      member do
        get 'snapshot_email' 
      end
      resources :mass_emails, only: [:new, :create]
      get 'toggle'
    end
    post 'remove_member_from_challenge', controller: 'challenges'
    post 'remove_group_from_challenge', controller: 'challenges'

    resources :memberships, only: [:edit, :update]
  end

  resources :contact_forms

  # member is a namespace for users in a challenge
  namespace :member do
    resources :challenges, only: [:index, :show] do
      resources :groups, only: [:new, :create, :edit, :index]
      resources :memberships, only: [:create]
    end
    resources :groups, except: [:new, :create, :index, :show] do
      member do
        post 'join'
        post 'leave'
      end
    end
    resources :memberships, only: [:update, :show, :destroy, :edit] do
      member do
        get 'unsubscribe'
        post 'sign_up_via_email'
      end
    end
  end

  resources :groups, only: [] do
    resources :comments, only: [:create, :destroy], controller: 'groups/comments'
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
