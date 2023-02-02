require 'test_helper'

class Api::V1::ReservationsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup_valid(code)
    assert_difference ["Reservation.count", "Guest.count"], 1 do
      post create_update_api_v1_reservations_url, params: {
        "reservation_code": code,
        "start_date": "2021-04-14",
        "end_date": "2021-04-18",
        "nights": 4,
        "guests": 4,
        "adults": 2,
        "children": 2,
        "infants": 0,
        "status": "accepted",
        "guest": {
          "first_name": Faker::Name.first_name,
          "last_name": Faker::Name.last_name,
          "phone": "639123456789",
          "email": Faker::Internet.safe_email
        },
        "currency": "AUD",
        "payout_price": "4200.00",
        "security_price": "500",
        "total_price": "4700.00"
      }
    end
  end

  test "should process a valid reservation" do
    assert_difference ["Reservation.count", "Guest.count"], 1 do
      post create_update_api_v1_reservations_url, params: {
        "reservation_code": "YYY#{Faker::Number.number(digits: 8)}",
        "start_date": "2021-04-14",
        "end_date": "2021-04-18",
        "nights": 4,
        "guests": 4,
        "adults": 2,
        "children": 2,
        "infants": 0,
        "status": "accepted",
        "guest": {
          "first_name": Faker::Name.first_name,
          "last_name": Faker::Name.last_name,
          "phone": "639123456789",
          "email": Faker::Internet.safe_email
        },
        "currency": "AUD",
        "payout_price": "4200.00",
        "security_price": "500",
        "total_price": "4700.00"
      }, as: :json

      assert_response :ok
    end
  end

  test "should not process when payload is not recognized" do
    assert_no_difference ["Reservation.count", "Guest.count"] do
      post create_update_api_v1_reservations_url, params: {
        "hello": "world"
      }, as: :json
      assert_response :not_found
    end
  end

  test "should not process when payload has missing required attributes" do
    assert_no_difference ["Reservation.count", "Guest.count"] do
      post create_update_api_v1_reservations_url, params: {
        "reservation_code": "YYY#{Faker::Number.number(digits: 8)}",
        "start_date": "2021-04-14",
        "end_date": "2021-04-18",
        "nights": 4,
        "guests": 4,
        "adults": 2,
        "children": 2,
        "infants": 0,
        "status": "accepted",
        "currency": "AUD",
        "payout_price": "4200.00",
        "security_price": "500",
        "total_price": "4700.00"
      }, as: :json
      assert_response :bad_request
    end
  end

  test "should update status" do
    code = "YYY#{Faker::Number.number(digits: 8)}"

    setup_valid(code)

    assert Reservation.find_by(code: code).status == "accepted"

    assert_no_difference ["Reservation.count", "Guest.count"] do
      post create_update_api_v1_reservations_url, params: {
        "reservation_code": code,
        "status": "declined"
      }, as: :json

      assert Reservation.find_by(code: code).status == "declined"
    end
  end

  test "should update occupancy details" do
    code = "YYY#{Faker::Number.number(digits: 8)}"

    setup_valid(code)

    r = Reservation.find_by(code: code)

    assert r.start_date.to_s == "2021-04-14"
    assert r.end_date.to_s == "2021-04-18"

    assert_no_difference ["Reservation.count", "Guest.count"] do
      post create_update_api_v1_reservations_url, params: {
        "reservation_code": code,
        "start_date": "2021-05-20",
        "end_date": "2021-05-23",
      }, as: :json

      r = Reservation.find_by(code: code)

      assert r.start_date.to_s == "2021-05-20"
      assert r.end_date.to_s == "2021-05-23"
    end

    assert r.guests == 4

    assert_no_difference ["Reservation.count", "Guest.count"] do
      post create_update_api_v1_reservations_url, params: {
        "reservation_code": code,
        "guests": 5
      }, as: :json

      r = Reservation.find_by(code: code)

      assert r.guests == 5
    end
  end

  test "should transfer reservation to another guest" do
    assert guests(:one).reservations.size == 2
    [reservations(:one), reservations(:two)].each do |r|
      assert guests(:one).reservations.include?(r)
    end

    assert guests(:two).reservations.size == 0

    post create_update_api_v1_reservations_url, params: {
      "reservation_code": reservations(:one).code,
      "guest": {
        "email": guests(:two).email
      }
    }

    assert_response :ok

    assert guests(:one).reservations.size == 1
    assert guests(:two).reservations.reload.size == 1
    assert guests(:two).reservations.reload.include?(reservations(:one))
  end
end
