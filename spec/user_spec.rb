require 'rails_helper'


RSpec.describe User, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('nickname', 'account_number')
    end
  end

  describe 'validates' do
    let(:valid_user) { User.new(nickname: 'validNickname', account_number: '16109010140000071219812874' ) } #valid account_number
    let(:invalid_user) { User.new(nickname: 'invalid_nickname_2', account_number: '1234') } #invalid account_number
    let(:empty_user) { User.new() } #empty User

    it { should allow_value(nil).for(:account_number) }
    it { should validate_length_of(:account_number).is_equal_to(26) }
    it { should allow_value(nil).for(:nickname) }
    it { should allow_value(valid_user.nickname).for(:nickname) }
    it { should_not allow_value(invalid_user.nickname).for(:nickname).with_message('must have only letters') }
    it { should allow_value(valid_user.account_number).for(:account_number) }
    it { should_not allow_value(invalid_user.account_number).for(:account_number) }
    it { should allow_value(empty_user.nickname).for(:nickname) }
    it { should allow_value(empty_user.account_number).for(:account_number) }
  end
end
