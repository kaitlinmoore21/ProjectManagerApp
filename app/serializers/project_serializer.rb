class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :due_date, :created_at, :updated_at
  
  # Embed the associated tasks when a project is retrieved
  has_many :tasks
end