class CreateSuborders < ActiveRecord::Migration[5.2]
  def change
    create_table :suborders do |t|
      t.integer :user_id
      t.integer :order_id
      t.text :food
      t.decimal :cost
      t.boolean :has_paid

      t.timestamps
    end
    add_index :suborders, :user_id
    add_index :suborders, :order_id
  end
end
