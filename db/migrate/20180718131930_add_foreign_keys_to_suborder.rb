class AddForeignKeysToSuborder < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :suborder, :orders
    add_foreign_key :suborder, :user, column: :suborderer_id
  end
end
