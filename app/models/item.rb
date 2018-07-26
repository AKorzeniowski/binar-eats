class Item < ApplicationRecord
  validates :user, :order, :food, :cost, presence: true

  belongs_to :user
  belongs_to :order

  scope :creator_order_items, ->(order_id, user_id) { where('order_id = ? AND user_id = ?', order_id, user_id) }
  scope :other_order_items, ->(order_id, user_id) { where('order_id = ?', order_id).where.not('user_id = ?', user_id) }
end
