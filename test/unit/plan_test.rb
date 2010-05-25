require File.dirname(__FILE__) + '/../test_helper'

class PlanTest < ActiveSupport::TestCase
  context "A plan" do
    setup do
      @plan = Factory :plan
    end

    teardown do
      Plan.delete_all
    end

    should "have some values" do
      assert_not_nil @plan.name
      assert_not_nil @plan.position
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
    
    should "i18n name" do
      I18n.locale = :en
      @plan.name = 'English'
      I18n.locale = :fr
      @plan.name = 'French'
      
      assert @plan.name = 'French'
      I18n.locale = :en
      assert @plan.name = 'English'
    end
  end
end
