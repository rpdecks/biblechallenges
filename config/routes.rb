Biblechallenge::Application.routes.draw do
  devise_for :users

  namespace :creator do
    resources :challenges, only: [:new, :create, :index]
  end

  # Memberships
  resources :memberships, only: [:index]

  # Challenges
  resources :challenges, only: [:index]
  get '/' => 'challenges#show', :constraints => { :subdomain => /.+/ }  # from railscasts 221

  root :to => 'high_voltage/pages#show', id: 'home'

end
