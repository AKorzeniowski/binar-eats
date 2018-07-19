class OrdersController < ApplicationController
  def new
    @order = Order.new
  end


  def create
    if params[:order][:orderer_id].to_i == -1
      params[:order][:orderer_id] = nil
    end
    if params[:order][:deliverer_id].to_i == -1
      params[:order][:deliverer_id] = nil
    end
    @order = Order.new(order_params)
    if @order.save
      redirect_to root_path, notice: 'Order was created'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:creator_id, :place_id, :orderer_id, :deliverer_id, :deadline)
  end
end
