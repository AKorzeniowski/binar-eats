require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ClearOldOrdersJob, type: :job do

  let!(:order1) { create(:order, deadline: Time.zone.today - 3.days) }
  let!(:order2) { create(:order, creator_id: order1.creator.id, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }
  let!(:order3) { create(:order, creator_id: order1.creator.id, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }

  subject	{	ClearOldOrdersJob.perform_now }

  describe 'old	orders' do
    before { subject }
    it { expect(Order.count).to eq(2) }
  end

end
