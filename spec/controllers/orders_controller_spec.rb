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

  describe '#done' do
    let!(:order) { create(:order) }

    before { get :done, params: { order_id: order.id } }

    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('done') }
    end

    context 'item' do
      it { expect(assigns(:item)).to be_a(Item) }
      it { expect(assigns(:item).persisted?).to eq(false) }
    end
  end

  describe '#edit' do
    login_user
    let!(:valid_order) { create(:order) }
    let!(:invalid_order) { create(:order, creator_id: valid_order.creator_id, orderer_id: valid_order.orderer_id, deliverer_id: valid_order.deliverer_id, deadline: Time.zone.now - 1.hours) }

    context 'creator' do
      before { subject.current_user.id = valid_order.creator.id }
      before { get :edit, params: { id: valid_order.id } }
      describe 'successful response' do
        it { expect(response).to be_successful }
        it { expect(response).to render_template('edit') }
      end

      context 'order' do
        it { expect(assigns(:order)).to eq(valid_order) }
      end
    end

    context 'user cant see others item' do
      before { get :edit, params: { id: valid_order.id } }
      it { expect(flash[:alert]).to be_present }
      it { expect(redirect_to(root_path)) }
    end

    context 'invalid order' do
      before { subject.current_user.id = valid_order.creator.id }
      before { get :edit, params: { id: invalid_order.id } }
      it { expect(redirect_to(orders_path)) }
      # it { expect(flash[:alert]).to be_present }
    end

  end

  describe '#create' do
    let!(:place)  { create(:place) }
    let!(:creator)  { create(:user) }
    let(:valid_attributes) { { order: attributes_for(:order, creator_id: creator.id, place_id: place.id) } }
    let(:invalid_attributes) { { order: attributes_for(:order, creator_id: nil, deadline: nil, place_id: nil) } }
    let(:want_be_orderer) { { order: attributes_for(:order, creator_id: creator.id, place_id: place.id, orderer_id: creator.id) } }
    let(:want_be_deliverer) { { order: attributes_for(:order, creator_id: creator.id, place_id: place.id), deliverer: creator.id } }
    let(:want_be_deliverer_and_orderer)  { { order: attributes_for(:order, creator_id: creator.id, place_id: place.id, orderer_id: creator.id), deliverer: creator.id } }
    let(:delivery_by_restaurant) { { order: attributes_for(:order, creator_id: creator.id, place_id: place.id), deliverer: -1 } }
    let!(:order_own_place) { { order: attributes_for(:order, creator_id: creator.id, place_id: 5), own_place_name: 'test', own_place_menu_url: 'https://own_place_menu_url.pl' } }

    context 'own place' do
      subject { post :create, params: order_own_place }

      it 'should add own place' do
        subject
        expect(Order.last.place.name).to eq('test')
        expect(Order.last.place.menu_url).to eq('https://own_place_menu_url.pl')
      end
    end

    context 'delivery by restaurant' do
      subject { post :create, params: delivery_by_restaurant }

      it 'delivery by restaurant can be true' do
        subject
        expect(Order.last.delivery_by_restaurant).to eq(true)
        expect(Order.last.deliverer).to eq(nil)
      end
    end

    context 'want be orderer' do
      subject { post :create, params: want_be_orderer }

      it 'should creator can be orderer' do
        subject
        expect(Order.last.orderer).to_not eq(nil)
        expect(Order.last.deliverer).to eq(nil)
        expect(Order.last.orderer.id).to eq(Order.last.creator.id)
      end
    end

    context 'want be deliverer' do
      subject { post :create, params: want_be_deliverer }

      it 'should creator can be deliverer' do
        subject
        expect(Order.last.orderer).to eq(nil)
        expect(Order.last.deliverer).to_not eq(nil)
        expect(Order.last.deliverer.id).to eq(Order.last.creator.id)
        expect(Order.last.delivery_by_restaurant).to eq(false)
      end
    end

    context 'want be deliverer and orderer' do
      subject { post :create, params: want_be_deliverer_and_orderer }

      it 'should creator can be deliverer' do
        subject
        expect(Order.last.orderer).to_not eq(nil)
        expect(Order.last.deliverer).to_not eq(nil)
        expect(Order.last.orderer.id).to eq(Order.last.creator.id)
        expect(Order.last.deliverer.id).to eq(Order.last.creator.id)
        expect(Order.last.delivery_by_restaurant).to eq(false)
      end
    end

    context 'valid params' do
      subject { post :create, params: valid_attributes }

      it 'should redirect to order_done' do
        subject
        expect(subject).to redirect_to(order_done_path(order_id: Order.last.id))
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

      it 'should not create new order' do
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
  		let(:order) { create(:order) }
      before{order.update(deliverer_id: subject.current_user.id)}
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

  describe '#send_payoff' do
    login_user
    let!(:item) { create(:item) }
    let!(:item2) { create(:item, user_id: item.user.id, order_id: item.order.id) }
    before { get :send_payoff, params: { id: item.order.id, order: item.order } }

    it 'should send two mails' do
      subject
      expect(item.order.items.where(has_paid: nil).count).to eq(2)
    end

    it 'should go to home page' do
      expect(subject).to redirect_to(orders_payment_path)
    end

    it 'should redirect with notice' do
      subject
      expect(flash[:notice]).to be_present
    end

  end
end
