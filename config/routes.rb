Biblechallenge::Application.routes.draw do
  devise_for :users

  namespace :creator do
    resources :challenges, only: [:new, :create, :index]
  end
  resources :memberships, only: [:index, :show]
  resources :challenges, only: [:index]
  constraints(Subdomaini) do
    match '/' => 'challenges#show'
  end

  root :to => 'high_voltage/pages#show', id: 'home'

end
