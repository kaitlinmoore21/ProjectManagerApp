# app/controllers/api/v1/tasks_controller.rb

module Api
  module V1
    class TasksController < Api::V1::ApplicationController

      # Use callbacks to handle finding and authorization
      before_action :set_task, only: %i[ show update destroy ]
      before_action :set_project, only: %i[ index create ] # For nested routes

      # GET /api/v1/projects/:project_id/tasks?status=pending
      def index
        # Ensures the list only includes tasks for the authenticated user and project
        @tasks = @project.tasks.where(user_id: current_user.id).order(due_date: :asc)
        
        # --- Filtering Logic ---
        if params[:status].present?
          # Looks up the integer value from the TASK_STATUSES constant in the Task model
          status_value = Task::TASK_STATUSES[params[:status].downcase.to_sym]
          
          # Only filter if the status name is valid (checks for 0 as well)
          if status_value.present? || status_value == 0
            @tasks = @tasks.where(status: status_value)
          end
        end

        render json: @tasks, status: :ok 
      end

      # GET /api/v1/tasks/:id 
      def show
        render json: @task, status: :ok
      end

      # POST /api/v1/projects/:project_id/tasks 
      def create
        @task = @project.tasks.build(task_params)
        @task.user = current_user # Security: Assign ownership to the logged-in user

        if @task.save
          render json: @task, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/tasks/:id 
      def update
        if @task.update(task_params)
          render json: @task, status: :ok
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tasks/:id 
      def destroy
        @task.destroy
        head :no_content 
      end

      private

      # Authorization for single task actions
      def set_task
        # Security: Finds the task only if it belongs to the current user
        @task = current_user.tasks.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Task not found or you do not have permission." }, status: :not_found
      end

      # Authorization for nested actions (index, create)
      def set_project
        # Security: Finds the project only if it belongs to the current user
        @project = current_user.projects.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Project not found or you do not have permission." }, status: :not_found
      end

      def task_params
        # Permitted parameters for tasks
        params.require(:task).permit(:title, :description, :status, :due_date) 
      end
    end
  end
end