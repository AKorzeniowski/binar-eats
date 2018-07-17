class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :id
      t.string :name
      t.string :address
      t.string :menu_url

      t.timestamps
    end
  end
end
