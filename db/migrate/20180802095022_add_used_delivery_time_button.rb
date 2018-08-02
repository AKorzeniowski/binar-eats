class AddUsedDeliveryTimeButton < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :used_delivery_time_button, :int
  end
end
