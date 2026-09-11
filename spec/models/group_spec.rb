require "rails_helper"

RSpec.describe Group, type: :model do
  it { should belong_to(:owner).class_name("User") }
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  it { should have_many(:users).through(:memberships) }
end