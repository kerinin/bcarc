require File.dirname(__FILE__) + '/../test_helper'

class Admin::PlansControllerTest < ActionController::TestCase
  context "Given data" do
    setup do
      @project = Factory :project
      @plan = Factory :plan, :project => @project
      @plan2 = Factory :plan, :project => @project
      @plan3 = Factory :plan, :project => @project
      @plan4 = Factory :plan, :project => @project
    end

    teardown do
      Project.delete_all
      Plan.delete_all
    end
        
    context "on GET to :new from project" do
      setup do
        get :new, :project_id => @project.to_param
      end
      should respond_with( :success)
    end
    
    context "on POST to :create" do
      setup do
        post :create, :project_id => @project.id, :plan => { :name => 'New Plan' }
      end
      should assign_to( :plan)
      should redirect_to('edit plan') { edit_admin_project_plan_path(@project, assigns['plan']) }
      should set_the_flash.to( "Plan was successfully created.")
      
      should "create a new plan" do
        assert_equal 1, Plan.find_all_by_name('New Plan').count
      end
    end
    
    context "on PUT to :update" do
      setup do
        put :update, :project_id => @project.id, :id => @plan.id, :plan => { :name => 'Changed Name' }
      end
      should assign_to( :plan)
      should redirect_to('edit plan') {edit_admin_project_plan_path(@project, assigns['plan'])}
      
      should "update the plan" do
        assert_equal 'Changed Name', assigns['plan'].name
      end
    end
    
    context "on GET to :destroy" do
      setup do
        get :destroy, :project_id => @project.id, :id => @plan.id
      end
      should redirect_to('plan index') {admin_project_plans_path( @project )}
      
      should "delete the plan" do
        assert !Plan.exists?( @plan )
      end
    end
    
    context "on GET to :sort" do
      setup do
        get :sort, :project_id => @project.to_param, 'plan-list' => [@plan3.id.to_s, @plan2.id.to_s, @plan4.id.to_s, @plan.id.to_s]
      end

      should respond_with(:success)

      should "update plan order" do
        assert_equal @plan3, @project.plans[0]
        assert_equal @plan2, @project.plans[1]
        assert_equal @plan4, @project.plans[2]
        assert_equal @plan, @project.plans[3]
      end
    end
  end
end
