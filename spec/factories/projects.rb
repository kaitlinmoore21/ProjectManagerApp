FactoryBot.define do
  factory :project do
    title { "Test Project" }
    description { "Project description" }
    status { 0 }
    due_date { Date.today + 7.days }
    association :user
  end
end
