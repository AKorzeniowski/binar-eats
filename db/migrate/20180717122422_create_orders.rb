class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.datetime :deadline
      t.decimal :delivery_cost
      t.references :creator
      t.references :orderer
      t.references :deliverer

      t.timestamps
    end
  end
end
