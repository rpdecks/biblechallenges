if Rails.env.production?
  # set this lower than unicorn timeout for debugging
  Rack::Timeout.timeout = 15 # seconds
end
