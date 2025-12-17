require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should have_many(:tasks).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:password).is_at_least(6) }
end
