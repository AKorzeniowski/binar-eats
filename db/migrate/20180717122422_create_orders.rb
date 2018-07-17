class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.datetime :deadline
      t.decimal :delivery_cost
      t.reference :creator
      t.reference :orderer
      t.reference :deliverer

      t.timestamps
    end
  end
end
