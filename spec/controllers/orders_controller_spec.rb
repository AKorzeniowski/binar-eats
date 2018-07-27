require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe '#index' do

      context 'successful response' do
        login_user
        before { get :index }
        it { expect(response).to be_successful }
        it { expect(response).to render_template('index')}
      end

      context 'orders' do
        login_user
        before { get :index }

        #my_orders
        let!(:order1) { create(:order, creator_id: subject.current_user.id, deadline: DateTime.now - 3.day) } #not today
        let!(:order2) { create(:order, creator_id: subject.current_user.id, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }
        let!(:order3) { create(:order, creator_id: subject.current_user.id, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }

        #other_orders
        let!(:order4) { create(:order, creator_id: subject.current_user.id + 1, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }
        let!(:order5) { create(:order, creator_id: subject.current_user.id + 2, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }
        let!(:order6) { create(:order, creator_id: subject.current_user.id + 2, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id, deadline: DateTime.now - 3.day) } #not today

        #creator_order_items
        let!(:item1) { create(:item, order_id: order1.id, user_id: subject.current_user.id) }
        let!(:item2) { create(:item, order_id: order1.id, user_id: subject.current_user.id) }

        #creator_order_items
        let!(:item3) { create(:item, order_id: order4.id, user_id: order4.creator_id) }
        let!(:item4) { create(:item, order_id: order5.id, user_id: order5.creator_id) }

        context 'my_orders' do
          it 'should return my orders' do
            subject
            expect(assigns(:my_orders)).to match_array([order2, order3])
            expect(assigns(:my_orders)).to_not match_array([order1, order4, order5, order6])
            expect(assigns(:my_orders).size).to eq(2)
          end
        end

        context 'other_orders' do
          it 'should return other orders' do
             subject
             expect(assigns(:other_orders)).to match_array([order4, order5])
             expect(assigns(:other_orders)).to_not match_array([order1, order2, order3, order6])
             expect(assigns(:other_orders).size).to eq(2)
           end
        end
      end
    end

  describe '#items' do
    login_user

    let!(:order1) { create(:order, creator_id: subject.current_user.id, deadline: DateTime.now) }
    let!(:order2) { create(:order, creator_id: subject.current_user.id, orderer_id: order1.orderer_id, deliverer_id: order1.deliverer_id) }

    #creator_order_items
    let!(:item1) { create(:item, order_id: order1.id, user_id: subject.current_user.id) }
    let!(:item2) { create(:item, order_id: order1.id, user_id: subject.current_user.id) }
    let!(:item3) { create(:item, order_id: order2.id, user_id: subject.current_user.id) }

    #other_order_items
    let!(:item4) { create(:item, order_id: order1.id, user_id: subject.current_user.id + 1) }
    let!(:item5) { create(:item, order_id: order1.id, user_id: subject.current_user.id + 1) }
    let!(:item6) { create(:item, order_id: order2.id, user_id: subject.current_user.id + 1) }

    before { get :items, params: { id: order1.id } }

    context 'creator_order_items' do
      it 'should return creator order items' do
        expect(assigns(:creator_order_items)).to match_array([item1, item2])
        expect(assigns(:creator_order_items)).to_not match_array([item3, item4, item5, item6])
        expect(assigns(:creator_order_items).size).to eq(2)
      end
    end

    context 'other_order_items' do
      it 'should return other order items' do
        expect(assigns(:other_order_items)).to match_array([item4, item5])
        expect(assigns(:other_order_items)).to_not match_array([item1, item2, item3, item6])
        expect(assigns(:other_order_items).size).to eq(2)
      end
    end

  end
  describe '#new' do
    before { get :new }

    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('new') }
    end

    context 'order' do
      it { expect(assigns(:order)).to be_a(Order) }
      it { expect(assigns(:order).persisted?).to eq(false) }
    end
  end
  describe '#edit' do
    login_user
    let(:order) { create(:order) }

    context 'creator' do
      before { subject.current_user.id = order.creator.id }
      before { get :edit, params: { id: order.id } }
      describe 'successful response' do
        it { expect(response).to be_successful }
        it { expect(response).to render_template('edit') }
      end

      context 'order' do
        it { expect(assigns(:order)).to eq(order) }
      end
    end

    context 'user cant see others item' do
      before { get :edit, params: { id: order.id } }
      it { expect(flash[:alert]).to be_present }
      it { expect(redirect_to(root_path)) }
    end

  end
  describe '#create' do
    let!(:place)  { create(:place) }
    let!(:creator)  { create(:user) }
    let(:valid_attributes) { { order: attributes_for(:order, creator_id: creator.id, place_id: place.id) } }
    let(:invalid_attributes) { { order: attributes_for(:order, creator_id: nil, deadline: nil, place_id: nil) } }

    context 'valid params' do
      subject { post :create, params: valid_attributes }

      it 'should redirect to orders' do
        expect(subject).to redirect_to(orders_path)
      end

      it 'should redirect with notice' do
        subject
        expect(flash[:notice]).to be_present
      end
    end

    context 'invalid params' do
      subject { post :create, params: invalid_attributes }
      it 'should render new' do
        expect(subject).to render_template('new')
      end

      it 'should not create new author' do
        expect{ subject }.not_to change{ Order.count }
      end
    end

  end
  describe '#update' do
    updated_deadline = Time.now.getlocal + 1.hours + 1.minute
		let(:order) { create(:order, delivery_time: nil) }
		let(:valid_attributes)	{	{	id:	order.id,	order:	{	deadline: updated_deadline, delivery_time: 3.hours.from_now} } }
		let(:invalid_attributes) {	{	id:	order.id,	order:	{	deadline: nil	}	}	}

    context 'valid params' do
      subject { patch :update, params: valid_attributes }
      it 'should redirect to orders index' do
        expect(subject).to redirect_to(orders_path)
      end

      it 'should redirect with notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      it 'should change order deadline' do
        subject
        expect(order.reload.deadline.getlocal.min).to eq(updated_deadline.min)
        expect(order.reload.deadline.getlocal.hour).to eq(updated_deadline.hour)
      end

      it 'should change order delivery time' do
        subject
        expect(order.reload.delivery_time).not_to eq(nil)
      end
    end

    context 'invalid params' do
      subject { patch :update, params: invalid_attributes }
      it 'should render edit' do
        expect(subject).to render_template('edit')
      end

      it 'should not change order deadline' do
        expect(order.reload.deadline.getlocal.min).to eq(order.deadline.getlocal.min)
        expect(order.reload.deadline.getlocal.min).to eq(order.deadline.getlocal.min)
      end

    end
  end

  describe '#payment' do
    context 'successful response' do
      login_user
  		let(:order) { create(:order, orderer_id: subject.current_user.id) }
      before { get :payment, params: { id: order.id } }
      it { expect(response).to be_successful }
      it { expect(response).to render_template('payment')}
    end

    context 'access denided' do
      login_user
  		let(:order) { create(:order) }
      before { get :payment, params: { id: order.id } }
      it { expect(flash[:alert]).to be_present }
      it { expect(redirect_to(root_path)) }
    end
  end
end
