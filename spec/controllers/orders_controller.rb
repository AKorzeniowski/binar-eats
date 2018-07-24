require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  login_user

  describe '#index' do
    subject { get :index }

    describe 'successful response' do
      before { subject }
      it { expect(response).to be_successful }
      it { expect(response).to render_template('index') }
    end

    # context 'my_orders' do
    #   let!(:order1) { Order.create(creator_id: subject.current_user.id, deadline: DateTime.now + 1, place_id: 1) }
    #   let!(:order2) { Order.create(creator_id: subject.current_user.id, deadline: DateTime.now + 1, place_id: 2) }
    #
    #   it 'should return only my orders' do
    #     get :index
    #     expect(assigns(:my_orders)).to match_array([order1, order2])
    #   end
    # end

  end
end
