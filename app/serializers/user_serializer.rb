class UserSerializer < ActiveModel::Serializer
  # Attributes for the profile endpoint
  attributes :id, :name, :email, :created_at
  
  # If you wanted to show the user's projects when the user profile is loaded:
   has_many :projects
end