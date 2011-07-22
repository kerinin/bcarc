require "openid/fetchers"
OpenID.fetcher.ca_file = "#{Rails.root}/cacert.crt"

require 'openid/store/filesystem'
#require 'openid/store/memcache'

#Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('./tmp'), :name => 'admin', :domain => 'bcarc.com'
#Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, OpenID::Store::Memcache.new(Dalli::Client.new), :name => 'admin', :domain => 'bcarc.com'

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :google_apps, OpenID::Store::Filesystem.new('./tmp')
  provider :openid, OpenID::Store::Filesystem.new('./tmp')
  #provider :openid, nil
  #provider :google_apps, nil
  #use OmniAuth::Strategies::GoogleApps, OpenID::Store::Filesystem.new('./tmp'), :name => 'admin', :domain => 'bcarc.com' #, :client_options => {:ssl => {:ca_file => './cacert.crt'}}
  #use OmniAuth::Strategies::GoogleApps, nil, :name => 'admin', :domain => 'bcarc.com'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid', :identifier => 'https://www.google.com/accounts/o8/id'
  #use OmniAuth::Strategies::OpenID, nil, :name => 'openid', :identifier => 'www.google.com/accounts/o8/site-xrds?hd=bcarc.com'
end


# This is failing due to a timeout on Heroku
# Omniauth doesn't want to work with either Dalli or memcached-northscale,
# but I don't think this is the problem, as it's saving the nonces in the
# temp folder

# The ssl certs fixed a warning about using HTTPS, but the timeout still occurs
# Not sure what's going on, but it appears to be happening before redirecting
# to google's page

# Might want to try implementing the OAuth protocol instead.  OAuth is really
# about access control to resources, but it might be enough for now

# This seems to be happening *after* authentication is granted on the callback
# It doesn't matter what I'm doing in the controller, so it's something on Omniauth's side
