class AddProviderAndUidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_index :users, :provider, unique: true
    add_column :users, :uid, :string
    add_index :users, :uid, unique: true
  end
end
