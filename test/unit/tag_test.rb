require 'test_helper'

class TagTest < ActiveSupport::TestCase
  context "A tag" do
    setup do
      @tag = Factory :tag, :name => 'Test Tag'
    end

    teardown do
      Tag.delete_all
    end

    should "have some values" do
      assert_equal @tag.name, 'Test Tag'
    end
  end
end
