class PaymentMailRedoJob < ApplicationJob
  queue_as :default

  def perform(order_id, sender)
    @order = Order.find(order_id)
    items = @order.items.where(has_paid: nil)
    items.each do |item|
      ApplicationMailer.payoff_mail(@order, sender, item).deliver_now
    end

    PaymentMailTimePassedJob.set(wait_until: 24.hours.from_now).perform_later(@order.id, sender)

  end
end
