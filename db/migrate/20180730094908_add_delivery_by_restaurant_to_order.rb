class AddDeliveryByRestaurantToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_by_restaurant, :boolean
  end
end
