class CreateSuborders < ActiveRecord::Migration[5.2]
  def change
    create_table :suborders do |t|
      t.references :suborderer, foreign_key: {to_table: :users} 
      t.references :order, foreign_key: true
      t.text :food
      t.decimal :cost
      t.boolean :has_paid

      t.timestamps
    end
  end
end
