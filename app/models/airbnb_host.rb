class AirbnbHost < Host

  def initialize(hsh)
    @name = "Airbnb"
    @payload = hsh

    @matchers = {
      guest: {
        email: [:guest, :email],
        firstname: [:guest, :first_name],
        lastname: [:guest, :last_name],
        phone: [:guest, :phone]
      },
      reservation: {
        code: [:reservation_code],
        status: [:status]
      },
      occupancy: {
        nights: [:nights],
        guests: [:guests],
        adults: [:adults],
        children: [:children],
        infants: [:infants],
        start_date: [:start_date],
        end_date: [:end_date]
      },
      price: {
        currency: [:currency],
        payout_price: [:payout_price],
        security_price: [:security_price],
        total_price: [:total_price]
      }
    }
  end

end