class Order < ApplicationRecord
  validates :creator, :deadline, presence: true

  belongs_to :creator, :class_name => "User"
  belongs_to :orderer, :class_name => "User"
  belongs_to :deliverer, :class_name => "User"
  belongs_to :place
end
