class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.string :email, index: { unique: true }
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.timestamps
    end
  end
end
