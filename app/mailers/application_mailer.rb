class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def payoff_mail
    @order = params[:order]
    @sender = params[:sender]
    @order.items.where(has_paid: nil).each do |item|
      @url  = item_payoff_url(id: item.id)
      @item = item
      mail(to: item.user.email, subject: "Payoff for your item from #{@order.place.name}.")
    end
  end
end
