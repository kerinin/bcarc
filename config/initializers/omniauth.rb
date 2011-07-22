require 'openid/store/filesystem'
#require 'openid/store/memcache'

#Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('./tmp'), :name => 'admin', :domain => 'bcarc.com'
#Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, OpenID::Store::Memcache.new(Dalli::Client.new), :name => 'admin', :domain => 'bcarc.com'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_apps, OpenID::Store::Filesystem.new('./tmp')
  use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('./tmp'), :name => 'admin', :domain => 'bcarc.com'
end

