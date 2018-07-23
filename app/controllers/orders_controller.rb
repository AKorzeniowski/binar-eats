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
    @my_orders = Order.where(creator_id: current_user.id, deadline: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
    @other_orders = Order.where.not(creator_id: current_user.id).where(deadline: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
  end

  def items
    @order_id = params[:id];
    @items = Item.where(order_id: @order_id, user_id: current_user.id)
  end


  private

  def order_params
    params.require(:order).permit(:creator_id, :place_id, :orderer_id, :deliverer_id, :deadline, :delivery_cost)
  end
end
