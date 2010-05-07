require File.dirname(__FILE__) + '/../test_helper'

class PlanTest < ActiveSupport::TestCase
  context "A plan" do
    setup do
      @plan = Factory :plan
    end

    teardown do
      Plan.delete_all
    end

    should_eventually "have some values" do
    end
    
    should_eventually "handle attached files" do
    end
    
    should_eventually "format thumbnails" do
    end
    
    should "raise error if image missing" do
      assert_raise ActiveRecord::RecordInvalid do
        v = Plan.new
        v.save!     
      end
    end
  end
end
