class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @post.save
      redirect_to root, notice: 'Order was created'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:deadline)
  end
end