Biblechallenge::Application.routes.draw do
  devise_for :users

  namespace :creator do
    resources :challenges, only: [:new, :show, :create, :index, :edit, :update] do
      get :activate, :on => :member
    end
  end

  resources :memberships, only: [:index, :show]
  resources :challenges, only: [:index]
  constraints(Subdomain) do
    match '/' => 'challenges#show'
  end

  root :to => 'high_voltage/pages#show', id: 'home'

end
