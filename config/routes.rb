Biblechallenge::Application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}

  namespace :creator do
    resources :challenges, only: [:new, :show, :create, :index, :edit, :update] do
      get :activate, on: :member
    end
  end

  resources :challenges, only: [:index] do
    resources :memberships, only: [:update, :edit, :index, :show, :create] 
  end

  constraints(Subdomain) do
    match '/' => 'challenges#show'
    match '/my-membership' => 'memberships#show'
    match '/memberships' => 'memberships#index'
  end

  root to: 'high_voltage/pages#show', id: 'home'

end
