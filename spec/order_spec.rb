require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('deadline', 'delivery_cost', 'creator_id', 'orderer_id', 'deliverer_id')
    end
  end


  describe 'relations' do
    it { have_one(:suborderer) }
    it { have_one(:orderer) }
    it { have_one(:deliverer) }
  end

end
