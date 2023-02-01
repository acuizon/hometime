class BookingHost < Host

  def initialize(hsh)
    @name = "Booking.com"
    @payload = hsh

    @matchers = {
      guest: {
        email: [:reservation, :guest_email],
        firstname: [:reservation, :guest_first_name],
        lastname: [:reservation, :guest_last_name],
        phone: [:reservation, :guest_phone_numbers]
      },
      reservation: {
        code: [:reservation, :code],
        status: [:reservation, :status_type]
      },
      occupancy: {
        nights: [:reservation, :nights],
        guests: [:reservation, :number_of_guests],
        adults: [:reservation, :guest_details, :number_of_adults],
        children: [:reservation, :guest_details, :number_of_children],
        infants: [:reservation, :guest_details, :number_of_infants],
        start_date: [:reservation, :start_date],
        end_date: [:reservation, :end_date]
      },
      price: {
        currency: [:reservation, :host_currency],
        payout_price: [:reservation, :expected_payout_amount],
        security_price: [:reservation, :listing_security_price_accurate],
        total_price: [:reservation, :total_paid_amount_accurate]
      }
    }
  end

  def assign_process(res, attr, str)
    res[attr] = (attr == :phone) ? str.join(", ") :str
  end

end