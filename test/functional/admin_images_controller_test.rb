require File.dirname(__FILE__) + '/../test_helper'

class Admin::ImagesControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project
      
      @image1 = Factory :image, :project => @project, :flickr_id => 4601892842
      @image2 = Factory :image, :project => @project
      
      @video1 = Factory :video, :project => @project
      @video2 = Factory :video, :project => @project
      
      @project.thumbnail = @image1
      @project.save!
      
      @flickr = Flickr.new(FLICKR_CONFIG[:flickr_cache_file], FLICKR_CONFIG[:flickr_key], FLICKR_CONFIG[:flickr_shared_secret])
      @flickr_cache = {:title => @flickr.photos.getInfo(4601892842).title, :description => @flickr.photos.getInfo(4601892842).description }
    end

    teardown do
      Project.all(:conditions => 'flickr_id IS NOT NULL').each {|p| @flickr.photosets.delete(p.flickr_id) }
      Project.delete_all
      Image.delete_all
      Video.delete_all
      @flickr.photos.setMeta(4601892842, @flickr_cache[:title], @flickr_cache[:description])
    end
        
    should_route :get, '/admin/projects/:project_id/Images/:id/pull_flickr', :controller => 'admin/images', :action => :pull_flickr, :project_id => ':project_id', :id => ':id', :locale => :en
    context "on GET to :pull_flickr" do
      setup do
        get :pull_flickr, :project_id => @project.to_param, :id => @image1.id
      end
      
      should "pull data from flickr" do
        assert_equal "Austin Modern Peninsula Lake House", assigns['image'].name
        assert assigns['image'].description.include? "The project begins with a"
      end
    end

    context "on GET to :pull_flickr with incorrect flickr_id" do
      setup do
        @image1.flickr_id = 999
        @image1.save!

        get :pull_flickr, :project_id => @project.to_param, :id => @image1.id
      end  
      should_respond_with :redirect
      should_redirect_to('edit image') { edit_admin_project_image_url(@project, @image1) }
      should_set_the_flash_to 'Error pulling from Flickr! (XMLRPC::FaultException)'
    end
  end
end
