module Api
  module V1
    class TasksController < Api::V1::ApplicationController
      # Ensure authentication and callbacks are correctly set

      # set_project is needed for ALL nested actions: index, create, update, destroy
      before_action :set_project 
      before_action :set_task, only: %i[ show update destroy ]

      # GET /api/v1/projects/:project_id/tasks
      def index
        @tasks = @project.tasks.where(user_id: current_user.id).order(due_date: :asc)
        
        if params[:status].present?
          status_value = Task::TASK_STATUSES[params[:status].downcase.to_sym]
          
          if status_value.present? || status_value == 0
            @tasks = @tasks.where(status: status_value)
          end
        end

        render json: @tasks, status: :ok 
      end

      # GET /api/v1/projects/:project_id/tasks/:id (Only if you ever need this, but we'll stick to nested update/destroy)
      def show
        render json: @task, status: :ok
      end

      # POST /api/v1/projects/:project_id/tasks 
      def create
        @task = @project.tasks.build(task_params)
        @task.user = current_user 

        if @task.save
          render json: @task, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/projects/:project_id/tasks/:id (NOW CORRECTLY NESTED)
      def update
        if @task.update(task_params)
          render json: @task, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/projects/:project_id/tasks/:id 
      def destroy
        @task.destroy
        head :no_content 
      end

      private

      # Authorization for single task actions
      def set_task
        
        @task = @project.tasks.find(params[:id]) 
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Task not found in this project or you do not have permission." }, status: :not_found
      end

      # Authorization for nested actions (needed for all CRUD)
      def set_project
        @project = current_user.projects.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Project not found or you do not have permission." }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :due_date) 
      end
    end
  end
end