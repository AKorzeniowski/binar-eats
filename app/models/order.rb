class Order < ApplicationRecord
  validates :creator, :deadline, presence: true

  has_one :creator, :class_name => "User"
  has_one :orderer, :class_name => "User"
  has_one :deliverer, :class_name => "User"
end
