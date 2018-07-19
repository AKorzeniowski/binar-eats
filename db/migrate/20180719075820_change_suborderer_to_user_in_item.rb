class ChangeSubordererToUserInItem < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :suborderer_id, :user_id
  end
end
