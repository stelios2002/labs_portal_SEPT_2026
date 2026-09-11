require "rails_helper"

RSpec.describe PostCategory, type: :model do
  it { should belong_to(:post) }
  it { should belong_to(:category) }
end