require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('user_id', 'order_id', 'food', 'cost', 'has_paid')
    end
  end

  describe 'validates' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:order) }
    it { should validate_presence_of(:food) }
    it { should validate_presence_of(:cost) }
  end

  describe 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:order) }
  end

end
