# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class Admin::BaseController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  # 
  
  before_filter :set_locale
  after_filter :expire_sitemap, :only => [:create, :update, :destroy]
  
  layout 'admin'
  
  protected
  
  def expire_sitemap
    expire_action web_sitemap_path
    expire_action image_sitemap_path
    #expire_action video_sitemap_path
    expire_action geo_sitemap_path
    expire_action sitemap_path
  end
  
  def set_locale
    I18n.locale = params[:locale] || :en
  end
end
