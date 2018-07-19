class ItemsController < ApplicationController
  def new
    @item = Item.new
    @order = Order.find_by_id(params[:id])
      redirect_to root_path, alert: "Order with id #{params[:id]} doesn't exist!" unless @order
  end

  def create
    # redirect_to root_path, notice: params
    @item = Item.new(item_params.merge(user_id: current_user.id, cost: 0) )
    if @item.save
      redirect_to root_path, notice: 'Item was created'
    else
      render :new
    end
  end

  private

  def item_params
    if params[:item][:cost] == nil
      params[:item][:cost] = 0
    end
    params.require(:item).permit(:food, :cost, :order_id, :orderer)
  end
end
