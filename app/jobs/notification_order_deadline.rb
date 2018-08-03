class NotificationOrderDeadline < ApplicationJob
  queue_as :default

  def perform(order_id)
    slack = SlackNotificationService.new
    order = Order.find(order_id)
    message = "Deadline for Order##{order.id} from #{order.place.name} will pass for 5 minutes."
    order.orderer_id = order.items.last.user.id if order.orderer_id.nil?
    slack.call(User.find(order.orderer_id).email, message)
  end
end
