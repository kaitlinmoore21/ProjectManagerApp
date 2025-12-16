class Task < ApplicationRecord
  
  # --- 1. Status Definition ---
  # Defines the mapping between descriptive labels and the integer values 
  STATUSES = { to_do: 0, in_progress: 1, complete: 2 }.freeze

  # --- 2. Associations (Foreign Keys) ---
  belongs_to :user      # The user assigned to the task (from the 'user:references' migration)
  belongs_to :project   # The project the task belongs to (assumed from context)

  # --- 3. Validations ---
  
  # Define ALL allowed values: integers (0, 1, 2) AND strings ("0", "1", "2")
  ALLOWED_STATUS_VALUES = STATUSES.values + STATUSES.values.map(&:to_s) 

  validates :status, 
            presence: true, 
            # This validation now accepts both 0 and "0"
            inclusion: { in: ALLOWED_STATUS_VALUES, message: "must be one of 0, 1, or 2" }
  
  # Ensure core fields are present
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true
  
  # Ensure 'due_date' is present (based on the validation error you fixed)
  validates :due_date, presence: true 
  
  # Ensure 'user_id' and 'project_id' are present 
  validates :user_id, presence: true
  validates :project_id, presence: true

end