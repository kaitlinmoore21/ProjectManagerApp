FactoryBot.define do
  factory :task do
    title { "Task title" }
    description { "Task description" }
    status { 0 }
    due_date { Date.today + 1.day }
    association :user
    association :project
  end
end
