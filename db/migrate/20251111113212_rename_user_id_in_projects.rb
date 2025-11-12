class RenameUserIdInProjects < ActiveRecord::Migration[8.1]
  def change
    # Remove old index first
    remove_index :projects, column: :User_id, if_exists: true

    # Rename the column
    rename_column :projects, :User_id, :user_id

    # Add index on the new column
    add_index :projects, :user_id
  end
end