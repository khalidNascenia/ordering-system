class ProductsController < ApplicationController
  def index
    @products = Product.all
    @order_item = current_order.order_items.new
  end

  def upload_edi

  end

  def process_edi
    @content = params[:file].read
    @data = Order.validate_edi(@content)
    @order = current_order
    if @data['valid'] && @order.create_order_from_edi(@data)
      flash[:notice] = 'Your purchase order has been successfully placed.'
      UserMailer.place_order(@order).deliver
    else
      flash[:error] = 'Your EDI is not valid!'
    end
    
    redirect_to upload_edi_path
  end
end
