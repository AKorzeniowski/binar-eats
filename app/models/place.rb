class Place < ApplicationRecord
  validates :name, presence: true
  validates :menu_url , presence: true
end
