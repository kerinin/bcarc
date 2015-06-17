require 'test_helper'
require 'performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionController::PerformanceTest
  def test_homepage
    get '/'
  end
  
  def test_default_tags
    get '/Work/residential'
  end
  
  def test_tags_by_chronology
    get '/Work/residential?by=time'
  end
  
  def test_project_show
    get '/Project/annie-residence'
  end
  
  def test_project_image_show
    get '/Project/annie-residence/images/212'
  end
  
  def test_page
    get '/Page/about'
  end
end
