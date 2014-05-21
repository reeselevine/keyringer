class Cart < ActiveRecord::Base
  attr_accessible :purchased_at
  has_many :line_items , :dependent => :destroy
  has_one :order

  def total_order_price
    unless line_items.nil?
      line_items.to_a.sum(&:full_price)
    end
  end

  def total_items
    unless line_items.nil?
      line_items.to_a.sum(&:quantity)
    end
  end
end
