Rails.application.routes.draw do
  root   "tasks#index"
  get    "/signup" => "users#new"
  post   "/signup" => "users#create"
  get    "/login"  => "sessions#new"
  post   "/login"  => "sessions#create"
  delete "/logout" => "sessions#destroy"

  resources :users, except: :index 
  resources :tasks, except: :index
  resources :labels
  namespace :admin do
    resources :users
  end
end
