class Project < ApplicationRecord
 

  STATUSES = { to_do: 0, in_progress: 1, complete: 2 }.freeze

  belongs_to :user
  has_many :tasks

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES.values }
  validates :due_date, presence: true
end