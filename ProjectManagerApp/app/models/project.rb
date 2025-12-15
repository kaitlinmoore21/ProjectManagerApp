class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  def status_class
    case status
    when "pending"
      "bg-yellow-200 text-yellow-800"
    when "in_progress"
      "bg-blue-200 text-blue-800"
    when "completed"
      "bg-green-200 text-green-800"
    when "cancelled"
      "bg-red-200 text-red-800"
    else
      "bg-gray-200 text-gray-800"
    end
  end

  def status_text
    status.present? ? status.titleize : "Unknown"
  end

  # 🧩 Add these methods to support progress tracking in your view
  def completed_tasks_count
    tasks.where(completed: true).count
  end

  def completion_percentage
    return 0 if tasks.count.zero?
    ((completed_tasks_count.to_f / tasks.count) * 100).round
  end
end
