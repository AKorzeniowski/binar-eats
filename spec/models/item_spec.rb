require 'rails_helper'

RSpec.describe Item, type: :model do


  describe 'validates' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:order) }
    it { should validate_presence_of(:food) }
    it { should validate_presence_of(:cost) }
  end

  describe 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:order) }
  end

end
