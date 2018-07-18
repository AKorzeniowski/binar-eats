require 'rails_helper'

RSpec.describe Suborder, type: :model do


  describe 'validates' do
    it { should validate_presence_of(:suborderer) }
    it { should validate_presence_of(:order) }
  end

  describe 'relations' do
    it { have_one(:suborderer) }
    it { have_one(:order) }
  end

end
