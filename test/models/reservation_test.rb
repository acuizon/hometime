require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  test "should not save if code not unique" do
    assert_no_difference "Reservation.count" do
      assert_not Reservation.new(code: reservations(:one).code, guest: guests(:one)).save
    end
  end

  test "should not save if code not present" do
    assert_no_difference "Reservation.count" do
      assert_not Reservation.new(guest: guests(:one)).save
      assert_not Reservation.new(guest: guests(:one), code: nil).save
      assert_not Reservation.new(guest: guests(:one), code: "").save
    end
  end

  test "should not save if no guest" do
    assert_no_difference "Reservation.count" do
      assert_not Reservation.new(code: "YYY87654321").save
      assert_not Reservation.new(code: "YYY12345678", guest: nil).save
    end
  end
end
