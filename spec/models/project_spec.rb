require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { build(:project) }

  it { should belong_to(:user) }
  it { should have_many(:tasks) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:due_date) }

  it "accepts valid status values" do
    Project::STATUSES.values.each do |value|
      subject.status = value
      expect(subject).to be_valid
    end
  end
end
