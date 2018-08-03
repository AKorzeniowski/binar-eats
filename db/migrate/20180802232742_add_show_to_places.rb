class AddShowToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :show, :boolean, default: false
  end
end
