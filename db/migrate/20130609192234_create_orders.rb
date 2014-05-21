class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :cart_id
      t.string :ip_address
      t.string :payment_method
      t.date :expire_date
      t.string :phone_number
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :province
      t.string :postal_code
      t.string :country

      t.timestamps
    end
  end
end
