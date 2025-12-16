Rails.application.routes.draw do
  # Health Check route (standard for Rails)
  get "up" => "rails/health#show", as: :rails_health_check

  # --- API V1 Namespace ---
  namespace :api do
    namespace :v1 do
      
      # 1. Authentication Endpoints
      post '/login', to: 'auth#login'
      post '/signup', to: 'auth#signup' # Handles user registration
      
      # 2. Protected Resources
      
      # Custom route for the current user's profile
      get '/profile', to: 'users#show' # Uses the JWT to fetch current_user

      # Project Resources
      resources :projects do 
        resources :tasks, only: [:index, :create] 
      end
      
      # Direct Task Resources
      resources :tasks, only: [:show, :update, :destroy] 
      
      
    end
  end
end