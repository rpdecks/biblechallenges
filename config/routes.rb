Biblechallenge::Application.routes.draw do

  if Rails.env.development?
    mount MailPreview => 'mail_view'
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users, controllers: { registrations: "users/registrations" }

  resource :profile, only: [:update, :edit]

  resources :challenges, only: [:new, :index, :show, :create, :destroy] do
    resources :groups, only: [:show, :create, :new, :destroy], controller: 'challenges/groups' do
      member do
        post 'join'
        post 'leave'
      end
    end
    resources :memberships, only: [:update, :index, :show, :create, :destroy] do
      collection do
        post 'create_for_guest'
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


  resources :public_challenges, only: [:index]
  root to: 'public_challenges#index'

end
