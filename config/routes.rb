Rails.application.routes.draw do

  devise_for :users
  resources :projects do
    member do
      get 'adduser' 
      get 'removeuser'
    end
    resources :bugs 
  end

  patch 'change_status', to: "bugs#change_status"
  delete 'remove_resolver', to: "bugs#remove_resolver"
  post 'assign_resolver', to: "bugs#assign_resolver"
  put "add", to: "projects#add"
  delete "remove", to: "projects#remove"
  post "/bugs/bug_status_options", to: 'bugs#bug_status_options'
 
  devise_scope :user do
    root :to => 'devise/registrations#new'
  end
  
end
