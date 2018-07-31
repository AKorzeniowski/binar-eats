class Order < ApplicationRecord
  validates :creator, :deadline, :place, presence: true

  belongs_to :creator, class_name: 'User'
  belongs_to :orderer, class_name: 'User', optional: true
  belongs_to :deliverer, class_name: 'User', optional: true
  belongs_to :place
  has_many :items, dependent: :destroy

  default_scope { order(deadline: :asc) }

  scope :old, -> {
    where('DATE(deadline) < ?', Time.zone.today)
  }

  scope :my_orders, ->(creator_id) {
    where('creator_id = ? AND DATE(deadline) = ?', creator_id, Time.zone.today)
  }
  scope :other_orders, ->(creator_id) {
    where.not('creator_id = ?', creator_id).where('DATE(deadline) = ?', Time.zone.today)
  }
end
