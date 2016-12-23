class RenameRelationshipColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :loans, :users_id, :user_id
    rename_column :loans, :boxes_id, :box_id
    rename_column :transactions, :loans_id, :loan_id
    rename_column :transactions, :users_id, :user_id
  end
end
