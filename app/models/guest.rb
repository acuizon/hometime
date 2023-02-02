class Guest < ApplicationRecord

  has_many :reservations

  validates :email, uniqueness: true, presence: true
  validates :firstname, :phone, presence: true

end
