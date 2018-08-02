class AddDeadlineNotificationToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :deadline_notification, :string
  end
end
