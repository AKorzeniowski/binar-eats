class OrderDeliveryNotificationJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    slack = SlackNotificationService.new
    order = Order.find(order_id)
    message = "Delivery for Order##{order.id} from #{order.place.name} will pass for 5 minutes."
    order.deliverer_id = order.items.last.user.id if order.deliverer_id.nil?
    slack.call(User.find(order.deliverer_id).email, message)
  end
end
