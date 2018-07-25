require 'rails_helper'

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
    let!(:order) { create(:order) }
    let(:valid_attributes) { { item: {food: 'Jedzenie', cost: 12.50, order_id: order.id} } }
    let(:invalid_attributes) { { item: {food: '', cost: nil} } }

    context 'valid params' do
      subject { post :create, params: valid_attributes }

      it 'should redirect to item' do
        expect(subject).to redirect_to(item_path 1 )
      end
      it 'should redirect with notice' do
        subject
        expect(flash[:notice]).to be_present
      end
      it 'should create new item' do
        expect{subject}.to change{ Item.count }.by(1)
      end
    end

    # context 'invalid params' do
    #   subject { post :create, params: invalid_attributes }
    #   it 'should render new' do
    #     expect(subject).to render_template('new')
    #   end
    #   it 'should not create new author' do
    #     expect{ subject }.not_to change{ Author.count }
    #   end
    # end
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

    context 'valid params' do
    subject { patch :update, params: valid_attributes }
      it 'should redirect to item index' do
        expect(subject).to redirect_to(item_path)
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
end
