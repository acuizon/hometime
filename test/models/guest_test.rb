require 'test_helper'

class GuestTest < ActiveSupport::TestCase
  test "should not save if email not unique" do
    assert_no_difference "Guest.count" do
      assert_not Guest.new(email: guests(:one).email).save
    end
  end

  test "should not save if email no present" do
    assert_no_difference "Guest.count" do
      assert_not Guest.new.save
      assert_not Guest.new(email: nil).save
      assert_not Guest.new(email: "").save
    end
  end
end
