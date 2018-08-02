class AddUsedOrderedButton < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :used_ordered_button, :int
  end
end
