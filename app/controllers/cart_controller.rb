class CartController < ApplicationController
  def view
  end

  def checkout
    quantities = params[:quantity]
    if quantities.nil? || quantities.empty?
      redirect_to :controller => "product", :action => "list"
    end
    quantities.each do |key, value|
      line_item = LineItem.find(key)
      if value == "0"
        line_item.delete
      else
        line_item.quantity = value
        line_item.save!
      end
    end
    redirect_to :controller => "order", :action => "review"
  end

  def clear
    unless session[:cart_id].nil?
      current_cart.destroy unless current_cart.nil?
      session[:cart_id] = nil
    end
    redirect_to :controller => "product", :action => "list"
  end
end
