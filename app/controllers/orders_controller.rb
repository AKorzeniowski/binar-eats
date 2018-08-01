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

    @order.deliverer_id = params['deliverer'] if params['deliverer'].to_i >= 1
    @order.delivery_by_restaurant = true if params['deliverer'].to_i == -1

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
    return (redirect_to orders_path, alert: "In order with id #{params[:id]} deadline has passed!") if
    @order.deadline < Time.zone.now
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

  def destroy
    if Item.other_order_items(params[:id], current_user.id).count == 0
      order = Order.find(params[:id])
      order.destroy
      redirect_to orders_path, notice: 'Order was destroy'
    else
      redirect_to orders_path, alert: 'Order was not destroy - Someone add item to your order'
    end
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
    @order.allowed_to_see_payment?(current_user)
  end

  def done
    @order = Order.find(params[:order_id])
    @item = Item.new
  end

  def send_payoff
    @order = Order.find(params[:id])
    emails = []
    items = @order.items.where(has_paid: nil)
    items.each do |item|
      ApplicationMailer.payoff_mail(@order, current_user, item).deliver_now
      emails << item.user.email
    end

    redirect_to orders_payment_path, notice: "#{items.count} email/s sended to: #{emails}."
  end

  private

  def order_params
    params.require(:order).
      permit(:creator_id, :deliverer_id, :orderer_id, :place_id, :deadline, :delivery_cost, :delivery_time)
  end
end
