class CreateOccupancyDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :occupancy_details do |t|
      t.integer :nights
      t.integer :guests
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.date :start_date
      t.date :end_date
      t.references :reservation
      t.timestamps
    end
  end
end
