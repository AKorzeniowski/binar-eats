class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.orderer_id = current_user.id if params['orderer'].to_i == 1
    @order.deliverer_id = current_user.id if params['deliverer'].to_i == 1
    if @order.save
      redirect_to orders_path, notice: 'Order was created'
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    return (redirect_to orders_path, alert: "You can't see this order!") if
    current_user.id != @order.creator_id || current_user.id != @order.orderer_id
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to orders_path, notice: 'Order was updated'
    else
      render :edit
    end
  end

  def index
    @my_orders = Order.my_orders(current_user.id)
    @other_orders = Order.other_orders(current_user.id)
  end

  def items
    @creator_order_items = Item.creator_order_items(params[:id], current_user.id)
    @other_order_items = Item.other_order_items(params[:id], current_user.id)
  end

  private

  def order_params
    params.require(:order).permit(:creator_id, :place_id, :deadline, :delivery_cost, :delivery_time)
  end
end
