class Reservation < ApplicationRecord

  belongs_to :guest

  has_one :occupancy_detail
  has_one :price_detail

end
