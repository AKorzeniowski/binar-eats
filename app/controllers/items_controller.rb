class ItemsController < ApplicationController
  def new
    @item = Item.new
    @order = Order.find_by_id(params[:id])
      redirect_to root_path, alert: "Order with id #{params[:id]} doesn't exist!" unless @order
  end

  def create
    if params[:item][:cost] == ""
      params[:item][:cost] = 0
    end

    if params.has_key?(:orderer) && params[:orderer] == "true"
        ord = Order.find_by_id(params[:item][:order_id])
        ord.orderer_id = current_user.id
        ord.save
    end

    @item = Item.new(item_params.merge(user_id: current_user.id) )
    if @item.save
      redirect_to root_path, notice: 'Item was created'
    else
      render :new
    end
  end

  private
  def item_params
    params.require(:item).permit(:food, :cost, :order_id)
  end
end
