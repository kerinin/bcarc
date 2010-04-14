require 'test_helper'

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
  end
end
