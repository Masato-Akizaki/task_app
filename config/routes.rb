Rails.application.routes.draw do
  root   "tasks#index"
  get    "/signup" => "users#new"
  post   "/signup" => "users#create"
  get    "/login"  => "sessions#new"
  post   "/login"  => "sessions#create"
  delete "/logout" => "sessions#destroy"

  resources :users
  resources :tasks, except: :index
end
