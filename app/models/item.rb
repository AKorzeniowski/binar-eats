class Item < ApplicationRecord
  validates :user, :order, :food, :cost, presence: true

  belongs_to :user
  belongs_to :order
end
