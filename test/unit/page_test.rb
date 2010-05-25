require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  context "A page" do
    setup do
      @page = Factory :page, :name => 'Test Page', :content => 'Test Content'
    end

    teardown do
      Page.delete_all
    end

    should_eventually "have some values" do
      assert_equal @page.name, 'Test Page'
      assert_equal @page.content, 'Test Content'
      # i18n
    end
    
    should "i18n name" do
      I18n.locale = :en
      @page.name = 'English'
      I18n.locale = :fr
      @page.name = 'French'
      
      assert @page.name = 'French'
      I18n.locale = :en
      assert @page.name = 'English'
    end


    should "i18n content" do
      I18n.locale = :en
      @page.content = 'English'
      I18n.locale = :fr
      @page.content = 'French'
      
      assert @page.content = 'French'
      I18n.locale = :en
      assert @page.content = 'English'
    end
            
    should "not update permalink if name chaned for other locale" do
      perm = @page.permalink
      I18n.locale = :fr
      @page.name = "Another Name in French"
      @page.save!
      
      assert_equal perm, @page.permalink
    end
  end
end
