class AddRequiredColumnsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :status, :integer
    add_column :projects, :due_date, :date
    add_column :projects, :title, :string
  end
end