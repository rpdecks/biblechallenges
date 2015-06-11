if Rails.env.production?
  Rack::Timeout.timeout = 15 # seconds
end
