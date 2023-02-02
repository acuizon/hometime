class Reservation < ApplicationRecord

  belongs_to :guest

  has_one :occupancy_detail, dependent: :destroy
  has_one :price_detail, dependent: :destroy

  validates :code, uniqueness: true, presence: true

  def start_date
    self.occupancy_detail&.start_date
  end

  def end_date
    self.occupancy_detail&.end_date
  end

  def guests
    self.occupancy_detail&.guests
  end

end
