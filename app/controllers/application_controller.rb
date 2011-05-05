# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :load_tags
  #before_filter :set_locale_from_url
  before_filter :set_locale
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
    
  def legacy
    if params[:glob].include?( 'image' ) || params[:glob].include?( 'images' ) || params[:glob].include?( 'Image' ) || params[:glob].include?( 'Images' )
      image = Image.find_by_attachment_file_name( params[:glob][-1] )
      unless image.nil?
        redirect_to project_image_url(image.project, image) and return false
      end
    end
    
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end
  
  #def default_url_options(options={})
  #  { :locale => I18n.locale }
  #end
  
  private
  
  def set_locale
    I18n.locale = params[:locale] || :en
  end
  
  def load_tags
    @tags = Tag.all
  end
end
