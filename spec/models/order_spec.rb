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
  end

end
