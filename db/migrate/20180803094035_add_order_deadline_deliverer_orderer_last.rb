class AddOrderDeadlineDelivererOrdererLast < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :deadline_ord_deli_job, :string
  end
end
