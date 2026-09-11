require "rails_helper"

RSpec.describe Membership, type: :model do
  it { should belong_to(:group) }
  it { should belong_to(:user) }

  it "δεν επιτρέπει διπλή συμμετοχή στην ίδια ομάδα" do
    membership = create(:membership)
    duplicate = Membership.new(group: membership.group, user: membership.user)
    expect(duplicate).not_to be_valid
  end
end