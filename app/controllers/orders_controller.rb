class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to root_path, notice: 'Order was created'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:deadline)
  end
end
