class Place < ApplicationRecord
  validates :name, :menu_url, presence: true

  has_many :orders, dependent: :destroy

  scope :visible, -> { where(show: true) }
end
