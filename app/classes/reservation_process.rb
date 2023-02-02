class ReservationProcess

  def self.start(partner)
    data = partner.parse

    if data[:guest].present?
      guest = Guest.find_or_initialize_by(email: data[:guest][:email])
      
      unless guest.update(data[:guest])
        raise StandardError.new "Guest: #{guest.errors.full_messages.join(', ')}"
      end

      reservation_params = data[:reservation].merge(guest: guest)
    else
      # no guest details means possible update request for reservation details
      reservation_params = data[:reservation]
    end
    
    reservation = Reservation.find_or_initialize_by(code: data[:reservation][:code], partner: partner.name)
    
    if reservation.update(reservation_params)
      occupancy = OccupancyDetail.find_or_initialize_by(reservation_id: reservation.id)
      occupancy.update(data[:occupancy])

      price = PriceDetail.find_or_initialize_by(reservation_id: reservation.id)
      price.update(data[:price])
    else
      raise StandardError.new "Reservation: #{reservation.errors.full_messages.join(', ')}"
    end
  end

end