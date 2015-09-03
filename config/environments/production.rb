Biblechallenge::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  config.eager_load = true
  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  
  if ENV['STAGING']
    config.action_mailer.default_url_options = { host: 'bc-staging.herokuapp.com' }
  else
    config.action_mailer.default_url_options = { host: 'biblechallenges.com' }
  end

  # if ENV staging is set, send email to mailtrap
  if ENV['STAGING']
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :user_name => ENV["MAILTRAP_USER_NAME"],
      :password => ENV["MAILTRAP_PASSWORD"],
      :address => 'mailtrap.io',
      :domain => 'mailtrap.io',
      :port => '2525',
      :authentication => :cram_md5
    }
  else  # we must be in production
    ActionMailer::Base.smtp_settings = {
    :port =>           '587',
    :address =>        'smtp.mandrillapp.com',
    :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'heroku.com',
    :authentication => :plain
    }
    ActionMailer::Base.delivery_method = :smtp
  end

  # paperclip with s3 storage
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV["AWS_BUCKET_NAME"],
    }
  }


  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[PREFIX] ",
      :sender_address => %{"Bible Challenges Exception Notifier" <notifier@biblechallenges.com>},
      :exception_recipients => %w{pdbradley@gmail.com}
    },
    :slack => {
      :webhook_url => "https://hooks.slack.com/services/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",
      :channel => "#biblechallenges"
    }

end
