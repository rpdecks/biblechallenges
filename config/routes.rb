Biblechallenge::Application.routes.draw do


  # mail_view stuff
  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end
  #end mail view


  devise_for :users, controllers: { registrations: "users/registrations" }

  resource :profile, only: [:update, :edit]

  namespace :creator do
    resources :challenges
  end

  # member is a namespace for users in a challenge
  namespace :member do
    resources :challenges, only: [:new, :create, :destroy, :index, :show] do
      resources :groups, only: [:new, :create]
      resources :memberships, only: [:create] 
    end
    resources :groups, except: [:new, :create] do
      member do
        post 'join'
        post 'leave'
      end
    end
    resources :memberships, only: [:update, :index, :show, :destroy] 
  end

  resources :badges, only: [:index, :show]

  resources :readings, only: [:show, :edit, :update] do
    resources :comments, only: [:create, :destroy], controller: 'readings/comments' 
  end

  resources :comments, only: [] do
    resources :comments, only: [:create], controller: "comments/comments"
  end

  get '/my-membership' => 'memberships#show', as: 'my_membership'
  get '/memberships' => 'memberships#index'

  # Unsubscribe from email
  get '/unsubscribe/:id' => 'memberships#unsubscribe_from_email', via: [:get], as: 'membership_unsubscribe'
  match '/unsubscribe/:id' => 'memberships#destroy', via: [:delete], as: 'membership_unsubscribe_destroy'

  # Logging readings
  match '/reading/confirm/:id' => 'membership_readings#confirm', via: [:get], as: 'membership_readings_confirm'
  match '/reading/log/:id' => 'membership_readings#log', via: [:put], as: 'membership_readings_log'

  # more restful reading logging
  resources :membership_readings, only: [:edit, :update] do
  end


  resources :challenges, only: [:index, :show], controller: 'challenges'
  root to: 'challenges#index'

end
