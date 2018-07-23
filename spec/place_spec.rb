require 'rails_helper'

RSpec.describe Place, type: :model do


  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:menu_url) }
  end

  describe 'relations' do
    it { should have_many(:orders) }
  end
end
