Rails.application.routes.draw do
  root   "tasks#index"
  get    "/signup" => "users#new"
  post   "/signup" => "users#create"
  get    "/login"  => "sessions#new"
  post   "/login"  => "sessions#create"
  delete "/logout" => "sessions#destroy"
  post   "/tasks/new" => "tasks#create"
  patch  "/tasks/:id/edit" => "tasks#update"
  post   "/labels/new" => "labels#create"
  patch  "/labels/:id/edit" => "labels#update"
  post   "/admin/users/new" => "admin/users#create"
  patch  "/admin/users/:id/edit" => "admin/users#update"


  resources :users, except: [:index, :new, :create, :update] 
  resources :tasks, except: [:index, :create, :update] 
  resources :labels, except: [:create, :update] 
  namespace :admin do
    resources :users, except: [:create, :update] 
  end
  
  get '*path', controller: 'application', action: 'render_404'
end
