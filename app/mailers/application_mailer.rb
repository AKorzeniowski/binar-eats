class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def payoff_mail
    @order = params[:order]
    @sender = params[:sender]
    @item = params[:item]
    @url  = item_payoff_url(id: @item.id)
    mail(to: @item.user.email, subject: "Payoff for your item from #{@order.place.name}.")
  end
end
