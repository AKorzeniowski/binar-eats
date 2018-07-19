class Order < ApplicationRecord
  validates :creator, :deadline, :place, presence: true

  belongs_to :creator, :class_name => "User"
  belongs_to :orderer, :class_name => "User", optional: true
  belongs_to :deliverer, :class_name => "User", optional: true
  belongs_to :place
end
