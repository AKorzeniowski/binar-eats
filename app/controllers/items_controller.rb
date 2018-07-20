class ItemsController < ApplicationController
  def new
    @item = Item.new
    @order = Order.find_by_id(params[:id])
      redirect_to root_path, alert: "Order with id #{params[:id]} doesn't exist!" unless @order
  end

  def create
    message = 'Item was created!'

    if params[:item][:cost] == ""
      params[:item][:cost] = 0
    end

    if params.has_key?(:orderer) && params[:orderer] == "true"
        ord = Order.find_by_id(params[:item][:order_id])
        ord.orderer_id = current_user.id
        if ord.save
          message += " Now you are orderer for order #{ord.id}!"
        end
    end

    if params.has_key?(:deliverer) && params[:deliverer] == "true"
        ord = Order.find_by_id(params[:item][:order_id])
        ord.deliverer_id = current_user.id
        ord.save
        if ord.save
          message += " Now you are deliverer for order #{ord.id}!"
        end
    end

    @item = Item.new(item_params.merge(user_id: current_user.id) )
    if @item.save
      redirect_to root_path, notice: message
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])

    @orderer = @item.order.orderer.nickname
    if @orderer == nil
      @orderer = @item.order.orderer.email
    end
    @deliverer = @item.order.deliverer.nickname
    if @deliverer == nil
      @deliverer = @item.order.deliverer.email
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to root_path, notice: 'Item was updated!'
    else
      render :show
    end
  end

  private
  def item_params
    params.require(:item).permit(:food, :cost, :order_id)
  end
end
