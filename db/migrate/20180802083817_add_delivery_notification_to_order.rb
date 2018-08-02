class AddDeliveryNotificationToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_notification, :string
  end
end
