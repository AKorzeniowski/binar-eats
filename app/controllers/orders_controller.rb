class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_path, notice: 'Order was created'
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
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
    today = Time.now.getlocal.beginning_of_day..Time.now.getlocal.end_of_day
    @my_orders = Order.where(creator_id: current_user.id, deadline: today)
    @other_orders = Order.where.not(creator_id: current_user.id).where(deadline: today)
  end

  def items
    @items = Item.where(order_id: params[:id], user_id: current_user.id)
  end

  private

  def order_params
    params.require(:order).permit(:creator_id, :place_id, :orderer_id, :deliverer_id, :deadline, :delivery_cost, :delivery_time)
  end
end
