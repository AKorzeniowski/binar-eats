class AddDeliveryTime < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_time, :datetime
  end
end
