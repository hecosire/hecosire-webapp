Rails.application.routes.draw do

  root 'welcome#index'

  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: { sessions: "api/v1/sessions" }
      resources :records
    end
  end

  match '/records/stats' => 'records#stats', :via => :get
  match '/records/blog' => 'records#blog', :via => :get
  resources :records

end
