class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :due_date, :created_at, :updated_at
  
  # Embed the project and user IDs without fetching the full objects
  attribute :project_id
  attribute :user_id
end