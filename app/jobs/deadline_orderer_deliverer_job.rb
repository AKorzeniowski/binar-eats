class DeadlineOrdererDelivererJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    order.orderer_id = order.items.last.user_id if order.orderer_id.present?
    order.deliverer_id = order.items.last.user_id if order.delivery_by_restaurant == false
  end
end
