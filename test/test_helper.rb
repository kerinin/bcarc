ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
#require 'rubygems'
require 'rails/test_help'
#require 'will_paginate'
#require 'active_record'
#require 'test/unit'
#require 'logger'
require 'factory_girl'

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

class ActiveSupport::TestCase

end

#require "#{File.dirname(__FILE__)}/factories"

I18n.locale = "en-US"

ActionController::TestCase.class_eval do
  # special overload methods for "global"/nested params
  [ :get, :post, :put, :delete ].each do |overloaded_method|
    define_method overloaded_method do |*args|
      action,params,extras = *args
      super action, params || {}, *extras unless @params
      super action, @params.merge( params || {} ), *extras if @params
    end
  end
end

# test_helper.rb
class Test::Unit::TestCase # or class ActiveSupport::TestCase in Rails 2.3.x
  def without_timestamping_of(*klasses)
    if block_given?
      klasses.delete_if { |klass| !klass.record_timestamps }
      klasses.each { |klass| klass.record_timestamps = false }
      begin
        yield
      ensure
        klasses.each { |klass| klass.record_timestamps = true }
      end
    end
  end
end

# Include default lang on your test requests (test requests doesn't support default_url_options):
#require 'translate_routes_test_helper'
