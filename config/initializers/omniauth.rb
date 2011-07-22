require 'openid/store/filesystem'

#Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('./tmp'), :name => 'admin', :domain => 'bcarc.com'
Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, nil, :name => 'admin', :domain => 'bcarc.com'