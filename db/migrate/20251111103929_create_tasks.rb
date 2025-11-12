class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.string :status, null: false, default: "pending"
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
