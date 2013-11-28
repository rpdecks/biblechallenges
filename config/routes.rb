Biblechallenge::Application.routes.draw do

  devise_for :users, controllers: {registrations: "registrations"}

  namespace :creator do
    resources :challenges, only: [:new, :show, :create, :index, :edit, :update] do
      get :activate, on: :member
    end
  end

  resources :challenges, only: [:index] do
    resources :memberships, only: [:update, :edit, :index, :show, :create, :destroy] do
      collection do
        post 'create_for_guest'
      end
    end
  end

  resources :readings, only: [] do
    collection do
      put 'log/:hash', action: :log
    end
  end

  constraints(Subdomain) do
    match '/' => 'challenges#show'
    match '/my-membership' => 'memberships#show', as: 'my_membership'
    match '/memberships' => 'memberships#index'
  end

  root to: 'high_voltage/pages#show', id: 'home'

end