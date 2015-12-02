Bcrails::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  config.log_level = :info

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_files = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  # Memcached
  #config.cache_store = :mem_cache_store, Memcached::Rails.new
  #config.cache_store = :dalli_store

  config.eager_load = true

  # config.middleware.insert_before(ActionDispatch::Static, Rack::Session::Cookie, :secret => ENV['SESSION_SECRET'])
  #
  # config.middleware.insert_after(Rack::Session::Cookie, OmniAuth::Builder) do
  #   provider :open_id, :store => OpenID::Store::Filesystem.new('/tmp')
  # end
  #
  # config.middleware.insert_after(OmniAuth::Builder, RackFederatedAuth::Authentication) do |config|
  #   config.email_filter = /bcarc\.com$/
  #   config.auth_url = "/auth/open_id?openid_url=www.google.com/accounts/o8/id"
  #   config.failure_message = "Authentication failed - did you use your '@bcarc.com' email?"
  #   config.public_path_regexes = [/^(?!\/admin).*/]
  # end

  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true
  config.assets.version = '1.1'
end
