class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[index new create show edit update destroy]
  before_action :set_task, only: %i[show edit update destroy]

  # GET /projects/:project_id/tasks
  def index
    @tasks = @project ? @project.tasks.order(created_at: :desc) : current_user.tasks.order(created_at: :desc)
  end

  # GET /projects/:project_id/tasks/new
  def new
    @task = @project.tasks.build
  end

  # POST /projects/:project_id/tasks
  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      redirect_to project_tasks_path(@project), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = current_user.projects.find_by(id: params[:project_id])
    redirect_to projects_path, alert: "Project not found." unless @project
  end

  def set_task
    @task = @project.tasks.find_by(id: params[:id])
    redirect_to project_tasks_path(@project), alert: "Task not found." unless @task
  end

  def task_params
    params.require(:task).permit(:name, :description, :status)
  end
end
