require 'rails_helper'

RSpec.describe Item, type: :model do


  describe 'validates' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:order) }
  end

  describe 'relations' do
    it { should have_one(:user) }
    it { should have_one(:order) }
  end

end
