class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def payoff_mail
    @order = params[:order]

    @order.items.where(has_paid: nil).each do |item|
      @url  = url_for(action: "payoff", id:item.id, controller: 'items', only_path: false)
      @item = item
      mail(to: item.user.email, subject: "Payoff for your item from #{@order.place.name}.")
    end
  end
end
