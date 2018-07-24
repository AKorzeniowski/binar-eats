class Place < ApplicationRecord
  validates :name, :menu_url, presence: true

  has_many :orders, dependent: :destroy
end
