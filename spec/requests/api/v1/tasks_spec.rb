require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project, user: user) }

  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) do
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end

  describe "GET /api/v1/projects/:project_id/tasks" do
    it "returns tasks for the project" do
      get api_v1_project_tasks_path(project), headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "POST /api/v1/projects/:project_id/tasks" do
    let(:params) do
      {
        task: {
          title: "New Task",
          description: "Task description",
          status: 0,
          due_date: Date.today + 1.day
        }
      }.to_json
    end

    it "creates a task" do
      expect {
        post api_v1_project_tasks_path(project),
             params: params,
             headers: headers
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /api/v1/projects/:project_id/tasks/:id" do
    it "updates the task" do
      patch api_v1_project_task_path(project, task),
            params: { task: { status: 2 } }.to_json,
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(task.reload.status.to_i).to eq(2)
    end
  end

  describe "DELETE /api/v1/projects/:project_id/tasks/:id" do
    it "deletes the task" do
      expect {
        delete api_v1_project_task_path(project, task),
               headers: headers
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
