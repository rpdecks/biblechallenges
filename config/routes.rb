Biblechallenge::Application.routes.draw do
  devise_for :users

  resources :challenges, only: [:new, :create]

  root :to => redirect("challenges#new")

end
