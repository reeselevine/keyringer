class CreateOrderTransactions < ActiveRecord::Migration
  def change
    create_table :order_transactions do |t|
      t.integer :order_id
      t.string :action
      t.float :amount
      t.boolean :success
      t.string :authorization
      t.text :message
      t.text :params

      t.timestamps
    end
  end
end
