require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('deadline', 'delivery_cost', 'creator_id', 'orderer_id', 'deliverer_id', 'place_id')
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:deadline) }
    it { should validate_presence_of(:place) }
  end


  describe 'relations' do
    it { belong_to(:creator) }
    it { belong_to(:orderer) }
    it { belong_to(:deliverer) }
    it { belong_to(:place) }
    it { have_many(:items)}
  end

  describe 'see payment page' do
    let(:order) { create(:order) }

    it 'didnt allow to see' do
      expect(order.allowed_to_see_payment?(order.creator)).to eq(false)
    end

    describe 'allow to see if restaurant is doing delivery' do
      before{ order.update(delivery_by_restaurant: true) }
      before{ order.update(orderer_id: order.creator_id) }
      it { expect(order.allowed_to_see_payment?(order.creator)).to eq(true) }
    end

    describe 'allow to see id user is deliverer' do
      before{ order.update(deliverer_id: order.creator_id) }
      it { expect(order.allowed_to_see_payment?(order.creator)).to eq(true) }
    end
  end

end
