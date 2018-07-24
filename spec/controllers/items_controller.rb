require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe '#show' do
    let!(:item) { build(:item) }
    # before { get :show, params: { id: item.id } }

    describe 'succesful response' do
      it {expect(item.user.nickname).not_to be_empty}
      it { expect(response).to be_successful }
      # it { expect(response).to render_template('show') }
    end

  end

end
