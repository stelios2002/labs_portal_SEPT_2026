require "rails_helper"

RSpec.describe Course, type: :model do
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should validate_presence_of(:title) }
  it { should have_many(:enrollments).dependent(:destroy) }
end