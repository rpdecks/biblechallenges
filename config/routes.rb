Biblechallenge::Application.routes.draw do
  devise_for :users

  resources :challenges, only: [:new, :create, :index]

  root :to => 'high_voltage/pages#show', id: 'home'

end
