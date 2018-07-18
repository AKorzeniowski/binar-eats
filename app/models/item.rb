class Item < ApplicationRecord
  validates :user, :order, presence: true

  belongs_to :user
  belongs_to :order
end
