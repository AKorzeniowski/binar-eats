require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do

  describe '#update' do
    let(:user) { create(:user) }
    let!(:valid_attributes) {{user:{account_number: Faker::Number.number(26), nickname: Faker::Pokemon.name, password: user.password }}}

    # describe 'User update' do
    #   before{ sign_in user }
    #
    #   subject { post :update, params: valid_attributes }
    #
    #   it 'should change nickname and account number' do
    #     subject
    #     expect(controller.current_user.reload.nickname).to eq(valid_attributes[:user][:nickname])
    #     expect(controller.current_user.reload.account_number).to eq(valid_attributes[:user][:account_number])
    #   end
    # end

  end

end
