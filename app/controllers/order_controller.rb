class OrderController < ApplicationController
  def review
    if current_cart.total_items == 0
      redirect_to :controller => "product", :action => "list"
    end
  end

  def payment_info
    @order = Order.new(:express_token => params[:token])
    if params[:token].nil?
      @order.build_shipment
    end
  end

  def express
    setup_response = EXPRESS_GATEWAY.setup_purchase(current_cart.build_order.price_in_cents(current_cart.total_order_price),
                                                    :ip => request.remote_ip,
                                                    :return_url => url_for(:action => 'payment_info', :only_path => false),
                                                    :cancel_return_url => url_for(:action => 'review', :only_path => false)
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(setup_response.token)
  end

  def purchase
    @order = current_cart.build_order(params[:order])
    @order.ip_address = request.remote_ip
    if @order.save
      session[:order_id] = @order.id
      if @order.purchase(current_cart.total_order_price)
        redirect_to :action => "invoice"
      else
        redirect_to :action => "error"
      end
    else
      render :'order/payment_info'
    end
  end

  def invoice
    if session[:order_id] != nil
      @order = Order.find(session[:order_id])
      session[:order_id] = nil
    else
      redirect_to :controller => "product", :action => "list"
    end
  end

  def error
    if session[:order_id] != nil
      @order = Order.find(session[:order_id])
      session[:order_id] = nil
    else
      redirect_to :controller => "product", :action => "list"
    end
  end
end
