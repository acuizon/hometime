class Api::V1::ReservationsController < ApplicationController

  def create_update
    if ( partner = Host.get_partner(params) ).present?
      begin
        ReservationProcess.start(partner)

        render json: { message: "Reservation processed!" }, status: :ok
      rescue StandardError => e
        render json: { message: e.message }, status: :bad_request
      end
    else
      render json: { message: "Unable to match payload" }, status: :not_found
    end
  end

end
