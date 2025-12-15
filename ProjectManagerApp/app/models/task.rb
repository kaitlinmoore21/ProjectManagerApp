class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user  

  validates :name, presence: true
  validates :status, presence: true

  def status_class
    task_status = self.status || "" 
    case task_status.downcase
    when 'complete', 'done'
      'complete'
    when 'in-progress', 'in progress'
      'in-progress'
    when 'not-started', 'todo', 'to-do'
      'not-started'
    else
      'not-started'
    end
  end
end
