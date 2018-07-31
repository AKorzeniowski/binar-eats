class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def payoff_mail(order, sender, item)
    @order = order
    @sender = sender
    @item = item
    @url  = item_payoff_url(id: @item.id)
    mail(to: @item.user.email, subject: "Payoff for your item from #{@order.place.name}.")
  end
end
