require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  subject do
    described_class.new(
      title: "Test Task",
      description: "Task description",
      status: 0,
      due_date: Date.today + 1.day,
      user: user,
      project: project
    )
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:project_id) }

    it "accepts valid status values (integers and strings)" do
      Task::ALLOWED_STATUS_VALUES.each do |value|
        subject.status = value
        expect(subject).to be_valid
      end
    end

    it "rejects invalid status values" do
      subject.status = 99
      expect(subject).not_to be_valid
      expect(subject.errors[:status]).to include("must be one of 0, 1, or 2")
    end
  end
end
