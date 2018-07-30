require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'attributes' do
    it 'should have extra attributes' do
      expect(subject.attributes).to include('name', 'menu_url')
    end
  end

  describe 'validates' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:menu_url) }
  end

  describe 'relations' do
    it { should have_many(:orders) }
    it { expect(place).to have_many(:orders).dependent(:destroy) }
  end
end
