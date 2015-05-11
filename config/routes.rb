Biblechallenge::Application.routes.draw do


  # mail_view stuff
  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end
  #end mail view


  devise_for :users

  resource :profile, only: [:update, :edit]

  resources :challenges, only: [:new, :index, :show, :create, :destroy] do
    resources :groups, only: [:show], controller: 'challenges/groups'
    resources :memberships, only: [:update, :index, :show, :create, :destroy] do
      collection do
        post 'create_for_guest'
      end
      member do
        post 'join_group'
      end
    end
  end

  resources :readings, only: [:show, :edit, :update] do
    resources :comments, only: [:create, :destroy], controller: 'readings/comments' 
  end

  resources :comments, only: [] do
    resources :comments, only: [:create], controller: "comments/comments"
  end

  get '/my-membership' => 'memberships#show', as: 'my_membership'
  get '/memberships' => 'memberships#index'

  # Unsubscribe from email
  get '/unsubscribe/:hash' => 'memberships#unsubscribe_from_email', via: [:get], as: 'membership_unsubscribe'
  match '/unsubscribe/:hash' => 'memberships#destroy', via: [:delete], as: 'membership_unsubscribe_destroy'

  # Loging readings
  match '/reading/confirm/:hash' => 'membership_readings#confirm', via: [:get], as: 'membership_readings_confirm'
  match '/reading/log/:hash' => 'membership_readings#log', via: [:put], as: 'membership_readings_log'

  # more restful reading logging
  resources :membership_readings, only: [:edit, :update] do
  end


  resources :public_challenges, only: [:index]
  root to: 'public_challenges#index'

end
