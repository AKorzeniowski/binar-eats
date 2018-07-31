require "rails_helper"

RSpec.describe ApplicationMailer, :type => :mailer do
  describe "notify" do
    let(:item) { create(:item) }
    let(:mail) { ApplicationMailer.payoff_mail(item.order, item.order.creator, item)}

    it 'renders the subject' do
      expect(mail.subject).to eq("Payoff for your item from #{item.order.place.name}.")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([item.user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['no-reply@example.com'])
    end

  end
end
