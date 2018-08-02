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

    @order.orderer_id = params['orderer_id'] if params['orderer_id'].to_i >= 1

    @order.deliverer_id = params['deliverer'] if params['deliverer'].to_i >= 1
    @order.delivery_by_restaurant = true if params['deliverer'].to_i == -1

    if @order.save
      job = NotificationOrderDeadline.set(wait_until: @order.deadline - 5.minutes).perform_later(@order.id)
      @order.update(deadline_notification: job.job_id)
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
    date = convert_datetime(params['order'])
    if date && date < Time.zone.now
      flash[:alert] = 'Delivery time passed!'
      return render :edit
    end

    if @order.update(order_params)
      @order.update_delivery_notification if params['order']['delivery_time(1i)'] && @order.
          delivery_by_restaurant == false
      @order.update_deadline_notification
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
    if Item.other_order_items(params[:id], current_user.id).count.zero?
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

  def ordered
    order = Order.find(params[:id])
    slack = SlackNotificationService.new
    order.items.each do |item|
      info = "Your order ##{item.id} from #{order.place.name} was ordered!"
      info += "\nList of food you ordered: #{item.food}."
      slack.call(item.user.email, info)
    end
    order.update(used_ordered_button: 1)
    redirect_to orders_path, notice: "Information sended to #{order.items.count} users."
  end

  def delivery_info
    order = Order.find(params[:id])
    if order.delivery_time
      slack = SlackNotificationService.new
      order.items.each do |item|
        info = "Your order ##{item.id} from #{order.place.name}"
        info += " will be delivered on #{order.delivery_time.strftime('%F %H:%M')}!"
        slack.call(item.user.email, info)
      end
      order.update(used_delivery_time_button: 1)
      return redirect_to orders_path, notice: "Information sended to #{order.items.count} users."
    end
    redirect_to orders_path, alert: 'You need to set delivery time.'
  end

  private

  def order_params
    params.require(:order).
      permit(:creator_id, :deliverer_id, :orderer_id, :place_id, :deadline, :delivery_cost, :delivery_time)
  end

  def convert_datetime(date)
    if date.key?('delivery_time(1i)') && date.key?('delivery_time(2i)') &&
       date.key?('delivery_time(3i)') && date.key?('delivery_time(4i)') && date.key?('delivery_time(5i)')
      Time.new(date['delivery_time(1i)'].to_i, date['delivery_time(2i)'].to_i,
        date['delivery_time(3i)'].to_i, date['delivery_time(4i)'].to_i, date['delivery_time(5i)'].to_i).in_time_zone
    end
  end
end
