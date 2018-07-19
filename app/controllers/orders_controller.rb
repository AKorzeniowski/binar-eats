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
    # puts DateTime.new(params[:order]['deadline(1)'].to_i, params[:order]['deadline(2)'].to_i,
    #              params[:order]['deadline(3)'].to_i, params[:order]['deadline(4)'].to_i,
    #              params[:order]['deadline(5)'].to_i)
    # puts DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, params[:order]['deadline(4)'].to_i, params[:order]['deadline(5)'].to_i, 0)
    params.require(:order).permit(:place_id, :orderer_id, :deliverer_id)
    # puts 'coś tam' + params[:order][:deadline].to_s
  end
end
