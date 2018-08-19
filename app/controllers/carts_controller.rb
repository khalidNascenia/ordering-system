class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:place_order, :my_orders]
  def show
    @order_items = current_order.order_items
  end

  def place_order
    @order = current_order
    @order.user_id = current_user.id
    @order.order_status_id = 2
    if @order.save
      session[:order_id] = nil
      flash[:notice] = 'Your order has been placed successfully'
      UserMailer.place_order(@order).deliver
    else
      flash[:error] = 'Your order has not been placed. Please try again!'
    end
    redirect_to my_orders_path   
  end
  
  def my_orders
    @orders = current_user.orders
  end  
end
