Rails.application.routes.draw do

  resources :records

  devise_for :users
  root 'welcome#index'

end
