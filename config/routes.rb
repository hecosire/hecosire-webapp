Rails.application.routes.draw do

  get 'status' => 'status#index', :via => :get

  get 'how-it-works' => 'welcome#how_it_works', :via => :get
  get 'privacy-policy' => 'welcome#privacy_policy', :via => :get

  root 'welcome#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: { sessions: "api/v1/sessions" }
      resources :records
    end
  end

  match '/api/v1/users/sign_in' => 'application#index', via: :options

  match '/records/stats' => 'records#stats', :via => :get
  match '/records/aggregates' => 'records#aggregates', :via => :get
  match '/records/wordcloud' => 'records#wordcloud', :via => :get
  match '/records/log' => 'records#log', :via => :get
  match '/records/export' => 'records#export', :via => :get


  match '/care/for' => 'care#receivers', :via => :get

  resources :records

end
