Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      
      post '/login', to: 'sessions#create'
      post '/signup', to: 'auth#signup'
      get '/profile', to: 'users#show'

      resources :projects do 
 
        resources :tasks, only: [:index, :create, :update, :destroy] 
      end
      
     
      
    end
  end
end