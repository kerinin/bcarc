require "omniauth-openid"
OpenID.fetcher.ca_file = "#{Rails.root}/cacert.crt"

require 'omniauth-openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid, OpenID::Store::Filesystem.new('./tmp')

  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid', :identifier => 'https://www.google.com/accounts/o8/id'
end

