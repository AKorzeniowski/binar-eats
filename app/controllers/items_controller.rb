class ItemsController < ApplicationController
  def new
    @order = Order.find(params[:id])
    flash[:notice] = "Order with id #{params[:id]} doesn't exist!" unless @order
    if @order.deadline > Time.zone.now
      @item = Item.new
    else
      return redirect_to orders_path, alert: "In order with id #{params[:id]} deadline has passed!"
    end
  end

  def create
    message = 'Item was created!'
    params[:item][:cost] = params[:item][:cost].to_i
    ord = Order.find(params[:item][:order_id])

    if params[:orderer] == 'true'
      ord.update(orderer_id: current_user.id)
      message += " Now you are orderer for order #{ord.id}!"
    end

    if params[:deliverer] == 'true'
      ord.update(deliverer_id: current_user.id)
      message += " Now you are deliverer for order #{ord.id}!"
    end

    @item = Item.new(item_params.merge(user_id: current_user.id))

    return redirect_to order_items_path(@item.order.id), notice: message if @item.save
    render :new
  end

  def show
    @item = Item.find(params[:id])
    return redirect_to root_path, alert: "It's not your item!" if current_user.id != @item.user_id
    @orderer = @item.order.orderer.name unless @item.order.orderer_id.nil?
    @deliverer = @item.order.deliverer.name unless @item.order.deliverer_id.nil?
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      message = "Item #{params[:id]} was updated!"
      ord = Order.find(@item.order_id)

      if params[:orderer] == 'true'
        ord.update(orderer_id: current_user.id)
        message += " Now you are orderer for order #{ord.id}!"
      end

      if params[:deliverer] == 'true'
        ord.update(deliverer_id: current_user.id)
        message += " Now you are deliverer for order #{ord.id}!"
      end

      return redirect_to orders_payment_path(@item.order_id), notice: message if params[:item][:mode]
      return redirect_to order_items_path(@item.order.id), notice: message
    end
    redirect_to item_path(id: @item.id), method: :show
  end

  def destroy
    item = Item.where(id: params[:id]).first
    return render :show if item.blank?
    item.destroy
    redirect_to root_path, notice: 'Item was deleted!'
  end

  def payoff
    @item = Item.find(params[:id])
    return redirect_to root_path, alert: "It's, not your payoff!" unless current_user.id == @item.user.id
  end

  def payoff_confirm
    item = Item.find(params[:id])
    return redirect_to root_path, alert: "It's, not your payoff!" unless current_user.id == item.user.id
    item.update(has_paid: true)
    redirect_to root_path, notice: "Item #{item.id} payment confirmed!"
  end

  private

  def item_params
    params.require(:item).permit(:food, :cost, :order_id)
  end
end
