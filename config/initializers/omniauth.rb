require 'omniauth-openid'
OpenID.fetcher.ca_file = "#{Rails.root}/cacert.crt"

require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :open_id, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'openid', :identifier => 'https://www.google.com/accounts/o8/id'
end

