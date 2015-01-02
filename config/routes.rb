Rails.application.routes.draw do

  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      devise_for :users
      resources :records
    end
  end

  devise_for :users

  resources :records

end
