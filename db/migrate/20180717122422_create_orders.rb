class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.datetime :deadline
      t.decimal :delivery_cost
      t.references :creator, foreign_key: {to_table: :users} 
      t.references :orderer, foreign_key: {to_table: :users} 
      t.references :deliverer, foreign_key: {to_table: :users} 

      t.timestamps
    end
  end
end
