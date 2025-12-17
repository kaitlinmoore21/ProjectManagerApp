Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # You correctly identified your frontend's port
    origins 'http://localhost:3001' 
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      # IMPORTANT: Expose the Authorization header so the frontend can read the token upon login
      expose: ['Authorization'] 
  end
end

