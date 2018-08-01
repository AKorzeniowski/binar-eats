class NotificationOrderDeadline < ApplicationJob
  queue_as :default

  def perform(order_id)
    slack = SlackNotificationService.new
    message = "Deadline for Order##{order_id} will pass for 5 minutes."
    order = Order.find(order_id)
    order.orderer_id = order.creator_id if order.orderer_id == nil
    slack.call(User.find(order.orderer_id).email, message)
  end
end
