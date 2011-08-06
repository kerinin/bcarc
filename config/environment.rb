# Load the rails application
require File.expand_path('../application', __FILE__)

RoutingFilter::Locale.include_default_locale = false

# Initialize the rails application
Bcrails::Application.initialize!

