class Suborder < ApplicationRecord
  validates :suborderer, :order, presence: true

  has_one :suborderer, :class_name => "User"
  has_one :order, :class_name => "Order"
end
