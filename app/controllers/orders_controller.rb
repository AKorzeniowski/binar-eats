class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if order_params[:place_id].to_i > 4
      @place = Place.create(name: params['own_place_name'], menu_url: params['own_place_menu_url'])
      @order[:place_id] = @place.id
    end

    @order.orderer_id = params['orderer_id'] if params['orderer_id'].to_i > 1
    @order.deliverer_id = params['deliverer_id'] if params['deliverer_id'].to_i > 1

    if @order.save
      redirect_to order_done_path(order_id: @order.id), notice: 'Order was created'
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    return (redirect_to orders_path, alert: "You can't see this order!") if
    current_user.id != @order.creator_id && current_user.id != @order.orderer_id
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
    # rubocop:disable LineLength
    @other_order_items = Item.other_order_items(params[:id], current_user.id) if Order.find(params[:id]).creator_id == current_user.id
    # rubocop:enable LineLength
  end

  def payment
    @order = Order.find(params[:id])

    return redirect_to root_path, alert: "You dont't have permission to see this page." unless
    (current_user.id == @order.orderer_id && @order.deliverer_id) ||
    (current_user.id == @order.orderer_id)
  end

  def done
    @order_id = params[:order_id]
    @order = Order.find(params[:order_id])
    @item = Item.new
  end

  private

  def order_params
    params.require(:order).
      permit(:creator_id, :deliverer_id, :orderer_id, :place_id, :deadline, :delivery_cost, :delivery_time)
  end
end
