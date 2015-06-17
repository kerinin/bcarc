require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase
  context "A tag" do
    setup do
      @tag = FactoryGirl.create :tag, :name => 'Test Tag'
    end

    teardown do
      Tag.delete_all
    end

    should "have some values" do
      assert_equal @tag.name, 'Test Tag'
    end
    
    should "update legacy_permalinks on save" do
      old_param = @tag.to_param
      
      @tag.name = 'New Name'
      @tag.save
      
      assert_equal "#{old_param}", @tag.legacy_permalinks
    end
    
    should "i18n name" do
      I18n.locale = :en
      @tag.name = 'English'
      I18n.locale = :fr
      @tag.name = 'French'
      
      assert @tag.name = 'French'
      I18n.locale = :en
      assert @tag.name = 'English'
    end
            
    should "not update permalink if name chaned for other locale" do
      perm = @tag.permalink
      I18n.locale = :fr
      @tag.name = "Another Name in French"
      @tag.save!
      
      assert_equal perm, @tag.permalink
    end
  end
end
