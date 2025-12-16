class Api::V1::ProjectsController < Api::V1::ApplicationController
  
  # Runs set_project for single-project actions (show, update, destroy)
  before_action :set_project, only: %i[ show update destroy ]

  # GET /api/v1/projects?status=in_progress
  def index
    # 1. Start with all projects belonging to the currently authenticated user
    @projects = current_user.projects.all.order(due_date: :asc)
    
    # 2. --- Filtering Logic ---
    if params[:status].present?
      # Looks up the integer value from the STATUSES constant in the Project model
      status_value = Project::STATUSES[params[:status].downcase.to_sym]
      
      # Only filter if the status name is valid (checks for 0 as well)
      if status_value.present? || status_value == 0
        @projects = @projects.where(status: status_value)
      end
    end

    # The response will automatically use the ProjectSerializer
    render json: @projects, status: :ok 
  end

  # GET /api/v1/projects/1
  def show
    # @project is secured via set_project
    render json: @project, status: :ok
  end

  # POST /api/v1/projects
  def create
    # Creates the project and automatically assigns the current_user_id
    @project = current_user.projects.build(project_params)

    if @project.save
      render json: @project, status: :created
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/projects/1
  def update
    # @project is secured via set_project
    if @project.update(project_params)
      render json: @project, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/projects/1
  def destroy
    # @project is secured via set_project
    @project.destroy
    head :no_content 
  end

  private
    def set_project
      # Authorization check: Finds the project only if it belongs to the current user
      @project = current_user.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Project not found or you do not have permission.' }, status: :not_found
    end

    def project_params
      # Only permit fields the user should be allowed to set
      params.require(:project).permit(:title, :description, :status, :due_date)
    end
end