# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173", "https://property-busstop.onrender.com", "https://propertybusstop.com"
    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
      # credentials: true
  end
end
