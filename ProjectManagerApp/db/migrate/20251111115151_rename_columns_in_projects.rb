class RenameColumnsInProjects < ActiveRecord::Migration[8.1]
  def change
    rename_column :projects, :Name, :name
    rename_column :projects, :Description, :description
  end
end
