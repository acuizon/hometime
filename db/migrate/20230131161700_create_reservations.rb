class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.string :code, index: { unique: true }
      t.string :status
      t.references :guest
      t.timestamps
    end
  end
end
