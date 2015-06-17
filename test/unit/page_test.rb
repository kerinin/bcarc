require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  context "A page" do
    setup do
      @page = FactoryGirl.create :page, :name => 'Test Page', :content => 'Test Content'
    end

    teardown do
      Page.delete_all
    end

    should "have some values" do
      assert_equal @page.name, 'Test Page'
      assert_equal @page.content, 'Test Content'
    end
    
    should "update legacy_permalinks on save" do
      old_param = @page.to_param
      
      @page.name = 'New Name'
      @page.save
      
      assert_equal "#{old_param}", @page.legacy_permalinks
    end
  end
  
  context "An i18n'd page" do
    setup do
      I18n.locale = 'en'
      @page = FactoryGirl.create :page, :name => 'Test Page', :content => 'Test Content'
      I18n.locale = 'es'
      @page.content = 'Spanish Page'
      @page.save!
    end
    
    teardown do
      Page.delete_all
    end
    
    should "fallback to english" do
      I18n.locale = 'zh'
      assert_equal 'Test Content', @page.content
      assert_equal 'Test Content', Page.first.content
    end
  end
end
