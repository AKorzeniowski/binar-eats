require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('nickname', 'account_number')
    end
  end

  describe 'validates' do
    valid_user = User.new(nickname: 'validNickname', account_number: 16109010140000071219812874)
    invalid_user = User.new(nickname: 'invalid_nickname_2', account_number: 'invalid_account_number_161')
    empty_user = User.new()

    it { should allow_value(nil).for(:account_number) }
    it { should validate_length_of(:account_number).is_equal_to(26) }
    it { should allow_value(nil).for(:nickname) }
    it { should validate_numericality_of(:account_number).only_integer }

    it { should allow_value(valid_user.nickname).for(:nickname) }
    it { should_not allow_value(invalid_user.nickname).for(:nickname).with_message('must have only letters') }
    it { should allow_value(valid_user.account_number).for(:account_number) }
    it { should_not allow_value(invalid_user.account_number).for(:account_number) }
    it { should allow_value(empty_user.nickname).for(:nickname) }
    it { should allow_value(empty_user.account_number).for(:account_number) }
  end

  describe 'relations' do
    it { should have_many(:created_orders) }
    it { should have_many(:ordered_orders) }
    it { should have_many(:received_orders) }
    it { should have_many(:items) }
  end
end
