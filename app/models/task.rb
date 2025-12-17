# app/models/task.rb (FIXED to match frontend form values)

class Task < ApplicationRecord
# --- 1. Status Definition ---
# CORRECTED: Keys now match the values sent by TaskForm.js
 STATUSES = { pending: 0, in_progress: 1, completed: 2 }.freeze # <<< FIX APPLIED HERE

# --- 2. Associations (Foreign Keys) ---
 belongs_to :user
belongs_to :project
 # We need to allow the frontend strings AND the integer values
 ALLOWED_STATUS_VALUES = STATUSES.values + STATUSES.values.map(&:to_s) 
validates :status,
          presence: true,
          inclusion: { in: ALLOWED_STATUS_VALUES, message: "must be one of 0, 1, or 2" }

validates :title, presence: true, length: { minimum: 3, maximum: 100 }
validates :description, presence: true
validates :due_date, presence: true
validates :user_id, presence: true
validates :project_id, presence: true
end