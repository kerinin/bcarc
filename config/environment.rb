# Load the rails application
require File.expand_path('../application', __FILE__)

require 'bleak_house' if ENV['BLEAK_HOUSE']

RoutingFilter::Locale.include_default_locale = false

# Initialize the rails application
Bcrails::Application.initialize!

