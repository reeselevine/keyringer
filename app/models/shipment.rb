class Shipment < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :country, :method, :name, :order_id, :postal_code, :province, :state

  belongs_to :order
end
