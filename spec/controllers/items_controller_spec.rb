require 'rails_helper'

RSpec.shared_examples "valid attributes for creating item" do
  subject { post :create, params: params }

  it 'should redirect to order items path' do
    expect(subject).to redirect_to(order_items_path Item.all.last.order_id )
  end
  it 'should redirect with notice' do
    subject
    expect(flash[:notice]).to be_present
  end
  it 'should create new item' do
    expect{subject}.to change{ Item.count }.by(1)
  end
end

RSpec.shared_examples "valid attributes for updating item" do
  subject { patch :update, params: params }

  it 'should redirect to order items' do
    expect(subject).to redirect_to(order_items_path Item.all.last.order_id)
  end
  it 'should redirect with notice' do
    subject
    expect(flash[:notice]).to be_present
  end
  it 'should change food' do
    subject
    expect(item.reload.food).to eq('Jedzenie')
  end
  it 'should change cost' do
    subject
    expect(item.reload.cost).to eq(12.50)
  end
end

RSpec.describe ItemsController, type: :controller do

  describe '#new' do
    let!(:order) { create(:order) }
    before { get :new, params: { id: order.id } }
    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('new') }
    end
    context 'item' do
      it { expect(assigns(:item)).to be_a(Item) }
      it { expect(assigns(:item).persisted?).to eq(false) }
    end
  end

  describe '#create' do
    login_user
    let!(:order) { create(:order, orderer_id: nil, deliverer_id: nil) }
    let!(:valid_attributes) { { item: {food: 'Jedzenie', cost: 12.50, order_id: order.id} } }
    let(:invalid_attributes) { { item: {food: '', cost: nil} } }
    let(:want_be_orderer) { valid_attributes.merge( orderer: 'true') }
    let(:want_be_deliverer) { valid_attributes.merge( deliverer: 'true') }
    let(:want_be_orderer_and_deliverer) { want_be_orderer.merge( deliverer: 'true') }

    context 'valid params' do
      include_examples "valid attributes for creating item" do
        let(:params) { valid_attributes }
      end
    end

    context 'invalid params' do
      subject { post :create, params: invalid_attributes }
      it 'should render new' do
        expect(subject).to render_template('new')
      end
      it 'should not create new item' do
        expect{ subject }.not_to change{ Item.count }
      end
    end

    context 'want be orderer' do
      subject { post :create, params: want_be_orderer }

      include_examples "valid attributes for creating item" do
        let(:params) { want_be_orderer }
      end

      it 'user should be orderer' do
        subject
        item = Item.find(1)
        expect(item.order.orderer_id).not_to eq(nil)
      end
    end

    context 'want be deliverer' do
      subject { post :create, params: want_be_deliverer }

      include_examples "valid attributes for creating item" do
        let(:params) { want_be_deliverer }
      end

      it 'user should be deliverer' do
        subject
        item = Item.find(1)
        expect(item.order.deliverer_id).not_to eq(nil)
      end
    end

    context 'want be orderer and deliverer' do
      subject { post :create, params: want_be_orderer_and_deliverer }

      include_examples "valid attributes for creating item" do
        let(:params) { want_be_orderer_and_deliverer }
      end

      it 'user should be orderer' do
        subject
        item = Item.find(1)
        expect(item.order.orderer_id).not_to eq(nil)
      end

      it 'user should be deliverer' do
        subject
        item = Item.find(1)
        expect(item.order.deliverer_id).not_to eq(nil)
      end
    end

  end

  describe '#show' do
    let(:item) { create(:item) }

    context 'user cant see others item' do
      login_user
      before { get :show, params: { id: item.id } }
      it { expect(flash[:alert]).to be_present }
      it { expect(redirect_to(root_path)) }
    end

    context 'successful response' do
      login_user
      before { subject.current_user.id = item.user.id }
      before { get :show, params: { id: item.id } }

      it { expect(flash[:alert]).not_to be_present }
      it { expect(response).to be_successful }
      it { expect(response).to render_template('show') }
    end

  end

  describe '#update' do
    let(:item) { create(:item) }
    login_user
    before { get :show, params: { id: item.id } }

    let(:valid_attributes) { { id: item.id, item: {food: 'Jedzenie', cost: 12.50} } }
    let(:invalid_attributes) { { id: item.id, item: {food: '', cost: nil} } }
    let(:want_be_orderer) { valid_attributes.merge( orderer: 'true') }
    let(:want_be_deliverer) { valid_attributes.merge( deliverer: 'true') }
    let(:want_be_orderer_and_deliverer) { want_be_orderer.merge( deliverer: 'true') }
    let(:edit_from_payment) { { id: item.id, item: {food: 'Jedzenie', cost: 12.50, mode: true} } }

    context 'edit from payment' do
      subject { patch :update, params: edit_from_payment }

      it 'should redirect to payment page' do
        expect(subject).to redirect_to(orders_payment_path)
      end
    end

    context 'valid params' do
      include_examples "valid attributes for updating item" do
        let(:params) { valid_attributes }
      end
    end

    context 'want be orderer' do
      subject { patch :update, params: want_be_orderer }

      include_examples "valid attributes for updating item" do
        let(:params) { want_be_orderer }
      end

      it 'user should be orderer' do
        subject
        expect(item.order.orderer_id).not_to eq(nil)
      end
    end

    context 'want be deliverer' do
      subject { patch :update, params: want_be_deliverer }

      include_examples "valid attributes for updating item" do
        let(:params) { want_be_deliverer }
      end

      it 'user should be deliverer' do
        subject
        expect(item.order.deliverer_id).not_to eq(nil)
      end
    end

    context 'want be orderer and deliverer' do
        subject { patch :update, params: want_be_orderer_and_deliverer }

      include_examples "valid attributes for updating item" do
        let(:params) { want_be_orderer_and_deliverer }
      end

      it 'user should be orderer' do
        subject
        expect(item.order.orderer_id).not_to eq(nil)
      end

      it 'user should be deliverer' do
        subject
        expect(item.order.deliverer_id).not_to eq(nil)
      end
    end

    context 'invalid params' do
      subject { patch :update, params: invalid_attributes }
        it 'should dont render' do
          expect(subject).to render_template(nil)
        end
        it 'should not change food' do
          subject
          expect(item.reload.food).not_to eq('Jedzenie')
        end
      end
    end

  describe '#destroy' do
    let(:item) { create(:item) }
    subject { delete :destroy, params: { id: item.id } }

    it 'should redirect to home' do
      expect(subject).to redirect_to(root_path)
    end

    it 'should redirect with notice' do
      subject
      expect(flash[:notice]).to be_present
    end

    it 'should destroy author' do
      item
      expect{ delete :destroy, params: { id: item } }.to change{ Item.count }.by(-1)
    end
  end

  describe '#payoff' do
    let(:item) { create(:item) }
    login_user
    before { get :payoff, params: { id: item.id } }

    describe 'user without permission' do
      it 'should dont show page' do
        expect(subject).to redirect_to(root_path)
      end

      it 'should redirect with alert' do
        subject
        expect(flash[:alert]).to be_present
      end
    end
  end

end
