class CreatePriceDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :price_details do |t|
      t.string :currency
      t.string :payout_price
      t.string :security_price
      t.string :total_price
      t.references :reservation
      t.timestamps
    end
  end
end
