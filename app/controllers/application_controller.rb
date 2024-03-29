class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_cart

  def current_cart
    begin
      if session[:cart_id]
        @current_cart ||= Cart.find(session[:cart_id])
        session[:cart_id] = nil if @current_cart.purchased_at
      end
      if session[:cart_id].nil?
        @current_cart = Cart.create!
        session[:cart_id] = @current_cart.id
      end
      @current_cart
    rescue
    end
  end
end
