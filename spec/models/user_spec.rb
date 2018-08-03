require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('nickname', 'account_number')
    end
  end

  describe 'validates' do
    it { should validate_length_of(:account_number).is_equal_to(26) }
    it { should allow_values(nil, 16109010140000071219812874).for(:account_number) }
    it { should_not allow_values(1610901014000007121981287, 'invalidAccountNumber').for(:account_number) }
    it { should validate_numericality_of(:account_number).only_integer }
    it { should allow_values(nil, 'alphaNickname').for(:nickname) }
    it { should_not allow_value('_nickname', 'nickname1' ).for(:nickname).with_message('must have only letters') }
  end

  describe 'relations' do
    it { should have_many(:created_orders) }
    it { should have_many(:ordered_orders) }
    it { should have_many(:received_orders) }
    it { should have_many(:items) }
  end

  describe 'Admin? ' do
    let(:user) { build(:user) }

    context 'it is not' do
      it {expect(user.admin?).to eq(false)}
    end
    context 'it is' do
      before {user.update(admin: 1)}
      it {expect(user.admin?).to eq(true)}
    end
  end
end
