class OrderDeliveryNotificationJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    slack = SlackNotificationService.new
    message = "Delivery for Order##{order_id} will pass for 5 minutes."
    order = Order.find(order_id)
    order.deliverer_id = order.items.last.user.id if order.deliverer_id.nil?
    slack.call(User.find(order.deliverer_id).email, message)
  end
end
