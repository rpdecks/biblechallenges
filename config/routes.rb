Biblechallenge::Application.routes.draw do


  # mail_view stuff
  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end
  #end mail view


  devise_for :users

  resource :profile, only: [:update, :edit]

  namespace :creator do
    resources :challenges do
      member do
        get :activate
        get '/confirm/delete', action: :confirm_destroy
      end
    end
  end


  resources :challenges, only: [:index] do
    resources :memberships, only: [:update, :index, :show, :create, :destroy] do
      collection do
        post 'create_for_guest'
      end
    end
  end

  resources :readings, only: [:show] do
    resources :comments, only: [:create, :destroy], controller: 'readings/comments' 
  end

  constraints(Subdomain) do
    match '/' => 'challenges#show'
    match '/my-membership' => 'memberships#show', as: 'my_membership'
    match '/memberships' => 'memberships#index'

    # Unsubscribe from email
    match '/unsubscribe/:hash' => 'memberships#unsubscribe_from_email', via: [:get], as: 'membership_unsubscribe'
    match '/unsubscribe/:hash' => 'memberships#destroy', via: [:delete], as: 'membership_unsubscribe_destroy'

    # Loging readings
    match '/reading/confirm/:hash' => 'membership_readings#confirm', via: [:get], as: 'membership_readings_confirm'
    match '/reading/log/:hash' => 'membership_readings#log', via: [:put], as: 'membership_readings_log'

    # more restful reading logging
    resources :membership_readings, only: [:edit, :update] do
    end

  end

  root to: 'high_voltage/pages#show', id: 'home'

end
