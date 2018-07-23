class AddForeignKeysToSuborder < ActiveRecord::Migration[5.2]
  def change
    # add_foreign_key :suborders, :orders
    # add_foreign_key :suborders, :user, column: :suborderer_id
  end
end
