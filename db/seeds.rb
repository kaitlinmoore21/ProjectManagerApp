# Create an admin user
user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.password = "password123"
end
puts "Seeded User: #{user.email}"

# Create 20 sample projects
20.times do |i|
  project = Project.find_or_create_by!(title: "Project #{i + 1}", user: user) do |p|
    p.description = "Description for Project #{i + 1}"
    p.status = i % 3          # cycles through Project::STATUSES integers
    p.due_date = Date.today + (i + 1).weeks
  end

  # Create 3 tasks for each project
  3.times do |j|
    Task.find_or_create_by!(title: "Task #{j + 1} for #{project.title}", project: project, user: user) do |t|
      t.description = "Description for Task #{j + 1}"
      t.due_date = project.due_date + (j + 1).days
      t.status = Task::STATUSES[:pending] # match your Task model
    end
  end
end

puts "Seeded 20 projects with 3 tasks each for admin user."
