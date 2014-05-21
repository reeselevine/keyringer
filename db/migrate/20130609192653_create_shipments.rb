class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.integer :order_id
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :state
      t.string :province
      t.string :method

      t.timestamps
    end
  end
end
