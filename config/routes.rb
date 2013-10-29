Biblechallenge::Application.routes.draw do
  devise_for :users

  namespace :creator do
    resources :challenges, only: [:new, :create, :index]
  end

  root :to => 'high_voltage/pages#show', id: 'home'

end
