Rails.application.routes.draw do

  get 'status' => 'status#index', :via => :get

  root 'welcome#index'

  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: { sessions: "api/v1/sessions" }
      resources :records
    end
  end

  match '/records/stats' => 'records#stats', :via => :get
  match '/records/aggregates' => 'records#aggregates', :via => :get
  match '/records/wordcloud' => 'records#wordcloud', :via => :get
  match '/records/log' => 'records#log', :via => :get
  match '/records/export' => 'records#export', :via => :get

  resources :records

end
