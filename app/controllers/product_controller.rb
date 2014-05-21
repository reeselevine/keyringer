class ProductController < ApplicationController

  def view
    unless params[:id].nil?
      @product = Product.find(params[:id])
    end
  end

  def list
    @products = Product.all
  end

  def add_to_cart
    unless params[:id].nil?
      exist = false
      product = Product.find(params[:id])
      line_items = current_cart.line_items
      if !line_items.nil? && !line_items.empty?
        line_items.each do |line_item|
          if line_item.product_id == product.id
            line_item.quantity = line_item.quantity + 1
            line_item.save!
            exist = true
            break
          end
        end
        unless exist
          line_item = LineItem.new
          line_item.product_id = product.id
          line_item.cart_id = current_cart.id
          line_item.quantity = 1
          line_item.save!
          current_cart.line_items << line_item
        end
      else
        line_item = LineItem.new
        line_item.product_id = product.id
        line_item.cart_id = current_cart.id
        line_item.quantity = 1
        line_item.save!
        current_cart.line_items << line_item
      end
    end
    redirect_to :action => "list"
  end
end
