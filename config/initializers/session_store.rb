# Be sure to restart your server when you modify this file.

Bcrails::Application.config.session_store :cookie_store, :key => '_bcstudio_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Bcrails::Application.config.session_store :active_record_store

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
#ActionController::Base.session = {
#  :key         => '_bcstudio_session',
#  :secret      => '6c3cec80d2797bfee20a59c2ccdadc31b629052f0f9e0c0d88b8165a0625375336b19eda619212f4749ab03bcbda1c385b49cb91df3187fd6c29f5c9b859cc52'
#}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
