require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe '#welcome' do
    context 'logged user' do
      login_user
      before { get :welcome }

      it 'should redirect to orders' do
        # subject
        expect(subject).to redirect_to(orders_path)
      end
    end

    context 'successful response' do
      it { expect(response).to be_successful }
    end
  end

end
