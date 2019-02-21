if Rails.env.production?
  # set this lower than unicorn timeout for debugging
  Rack::Timeout.timeout = ENV['RACK_TIMEOUT_SERVICE_TIMEOUT'] # seconds
end
