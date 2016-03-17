if Rails.env == 'development'
  require 'rack-mini-profiler'

  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.authorize_request
end
