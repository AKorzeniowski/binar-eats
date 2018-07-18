class RenameSuborderToItem < ActiveRecord::Migration[5.2]
  def change
    rename_table :suborders, :items
  end
end
