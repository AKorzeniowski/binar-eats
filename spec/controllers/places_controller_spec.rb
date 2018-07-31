require 'rails_helper'

RSpec.describe PlacesController, type: :controller do

  describe '#index' do

    context 'successful response' do
      before { get :index }
      it { expect(response).to be_successful }
      it { expect(response).to render_template('index') }
    end

    context 'places' do
      before { get :index }
      let!(:place1) { create(:place) }
      let!(:place2) { create(:place) }
      let!(:place3) { create(:place) }

      it 'should return all places' do
        subject
        expect(assigns(:places)).to match_array([place1, place2, place3])
        expect(assigns(:places).size).to eq(3)
      end
    end

    context 'place' do
      before { get :index }
      it { expect(assigns(:place)).to be_a(Place) }
      it { expect(assigns(:place).persisted?).to eq(false) }
    end

  end
  describe '#create' do
    let(:valid_attributes) { { place: attributes_for(:place) } }
    let(:invalid_attributes) { { place: attributes_for(:place, name: nil, menu_url: nil) } }

    context 'valid params' do
      subject { post :create, params: valid_attributes }

      it 'should redirect to places' do
        subject
        expect(subject).to redirect_to(places_path)
      end

      it 'should redirect with notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      it 'should create new place' do
        expect{ subject }.to change{ Place.count }
      end
    end

    context 'invalid params' do
      subject { post :create, params: invalid_attributes }




      it 'should redirect to places' do
        subject
        expect(subject).to redirect_to(places_path)
      end

      it 'should redirect with alert' do
        subject
        expect(flash[:alert]).to be_present
      end

      it 'should not create new place' do
        expect{ subject }.not_to change{ Place.count }
      end
    end
  end
  describe '#edit' do
    let(:place) { create(:place) }
    before { get :edit, params: { id: place.id } }

    describe 'successful response' do
      it { expect(response).to be_successful }
      it { expect(response).to render_template('edit') }
    end

    context 'place' do
      it { expect(assigns(:place)).to eq(place) }
    end



  end
  describe '#update' do
    let(:place) { create(:place) }
    let(:valid_attributes) { { id: place.id, place: { name: 'test', menu_url: 'https://menu_url.pl' } } }
    let(:invalid_attributes) { { id: place.id, place: { name: nil, menu_url: nil } } }

    context 'valid params' do
      subject { patch :update, params: valid_attributes }

      it 'should redirect to places' do
        expect(subject).to redirect_to(places_path)
      end

      it 'should redirect with notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      it 'should change place name' do
        subject
        expect(place.reload.name).to eq('test')
      end

      it 'should change place menu url' do
        subject
        expect(place.reload.menu_url).to eq('https://menu_url.pl')
      end

      it 'should not change place count' do
        subject
        expect{ subject }.not_to change{ Place.count }
      end
    end

    context 'invalid params' do
      subject { patch :update, params: invalid_attributes }

      it 'should redirect to edit' do
        subject
        expect(response).to redirect_to(edit_place_path(place.id))
      end



    end

  end
  describe '#destroy' do
    let(:place) { create(:place) }

    describe 'place' do
      subject { delete :destroy, params: { id: place.id } }

      it 'should redirect to places' do
        expect(subject).to redirect_to(places_path)
      end

      it 'should redirect with notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      it 'should destroy place' do
        place
        expect{ delete :destroy, params: { id: place } }.to change{ Place.count }.by(-1)
      end

    end

  end
end
