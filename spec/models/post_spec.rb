require "rails_helper"

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3).is_at_most(150) }
  it { should validate_presence_of(:body) }
  it { should have_many(:categories).through(:post_categories) }
end