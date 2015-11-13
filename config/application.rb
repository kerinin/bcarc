require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'omniauth-openid'
require 'openid/store/filesystem'


# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Bcrails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    # This is a hack - hopefully future releases of Paperclip will make it unnecessary
    config.after_initialize do

      # copied from paperclip.rb: due to bundler, this doesn't seem to happen automagically anymore!?!
      Dir.glob(File.join(File.expand_path(Rails.root), "lib", "paperclip_processors", "*.rb")).each do |processor|
        require processor # PVDB don't rescue LoadError... let it rip!
      end

    end

    config.middleware.insert_before(ActionDispatch::Static, Rack::Session::Cookie, :secret => ENV['SESSION_SECRET'])

    config.middleware.insert_after(Rack::Session::Cookie, OmniAuth::Builder) do
      provider :open_id, :store => OpenID::Store::Filesystem.new('/tmp')
    end

    config.middleware.insert_after(OmniAuth::Builder, RackFederatedAuth::Authentication) do |config|
      config.email_filter = /bcarc\.com$/
      config.auth_url = "/auth/open_id?openid_url=www.google.com/accounts/o8/id"
      config.failure_message = "Authentication failed - did you use your '@bcarc.com' email?"
      config.public_path_regexes = [/^(?!\/admin).*/]
    end
  end
end
