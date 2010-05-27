require File.dirname(__FILE__) + '/../test_helper'

class Admin::TagsControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @tag = Factory :tag
    end

    teardown do
      Tag.delete_all
    end
        
    context "on POST to :create" do
      setup do
        post :create, :tag => {:name => 'New Tag' }
      end
      should_assign_to :tag
      should_redirect_to('edit tag') {edit_admin_tag_path(assigns['tag'])}
      
      should "create a new tag" do
        assert_equal 1, Tag.find_all_by_name('New Tag').count
      end
    end
    
    context "on PUT to :update" do
      setup do
        put :update, :id => @tag.id, :tag => { :name => 'Changed Name' }
      end
      should_assign_to :tag
      should_redirect_to('edit tag') {edit_admin_tag_path(assigns['tag'])}
      
      should "update the tag" do
        assert_equal 'Changed Name', assigns['tag'].name
      end
    end
    
    context "on GET to :destroy" do
      setup do
        get :destroy, :id => @tag.id
      end
      should_redirect_to('tag index') {admin_tags_path}
      
      should "delete the tag" do
        assert !Tag.exists?( @tag )
      end
    end
  end
end
