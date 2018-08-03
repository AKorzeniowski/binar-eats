class PaymentMailTimePassedJob < ApplicationJob
  queue_as :default

  def perform(order_id, sender)
    @order = Order.find(order_id)
    items = @order.items.where(has_paid: nil)
    @emails = []
    items.each do |item|
      @emails << item.user.email
    end

    ApplicationMailer.payment_mail(@order, sender, @emails).deliver_now unless @emails.size.!empty?
  end
end
