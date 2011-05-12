require File.dirname(__FILE__) + '/../test_helper'

class Admin::WebcamImagesControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project, :has_webcam => true
      @image = Factory :webcam_image, :project => @project
      @image2 = Factory :webcam_image, :project => @project
      @image3 = Factory :webcam_image, :project => @project
      @image4 = Factory :webcam_image, :project => @project
    end

    context "on GET to :index" do
      setup do
        get :index, :project_id => @project.to_param
      end
      
      should respond_with(:success)
      should assign_to(:webcam_images)
    end
    
    context "on PUT to :update" do
     setup do
       put :update, :project_id => @project.to_param, :id => @image.id, :webcam_image => { :date => Date::today - 5 }
     end
     should assign_to( :webcam_image)
     should redirect_to('edit image') {edit_admin_project_webcam_image_path(@project, assigns['webcam_image'])}

     should "update the image" do
       assert_equal Date::today - 5, assigns['webcam_image'].date.to_date
     end
    end

    context "on GET to :destroy" do
     setup do
       get :destroy, :project_id => @project.to_param, :id => @image.id
     end
     should redirect_to('image index') {admin_project_webcam_images_path( @project )}

     should "delete the image" do
       assert_does_not_contain @image, @project.webcam_images
     end
    end
  end
end
