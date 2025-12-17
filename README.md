# What You Need

# Make sure you have these installed:
Ruby: (We used 3.1.2+)

Rails: (7.0+)

PostgreSQL: (The database I went with)

# Directory :
 cd /mnt/c/ProjectManagerApplication/project_manager_backend

# install dependencies :
bundle install

# Database : 
rails db:create

rails db:migrate

# Load the Starter Data : This seeds the first user so you can actually log in.
rails db:seed

# Running the API : You must run API before Frontend
rails s

# Login Credentials :
USERNAME: test@project.com
PASSWORD: password