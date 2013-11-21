Biblechallenge::Application.routes.draw do
  devise_for :users

  namespace :creator do
    resources :challenges, only: [:new, :show, :create, :index, :edit, :update] do
      get :activate, :on => :member
    end
  end

  resources :memberships, only: [:update, :edit, :index, :show, :new, :create] 

  resources :challenges, only: [:index]

  constraints(Subdomain) do
    match '/' => 'memberships#new'
  end

  root :to => 'high_voltage/pages#show', id: 'home'

end
