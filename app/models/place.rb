class Place < ApplicationRecord
  validates :name, presence: true
  validates :menu_url , presence: true

  has_many :orders
end
