require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:enrollments).dependent(:destroy) }
  it { should have_many(:courses).through(:enrollments) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:groups).through(:memberships) }

  it "κρυπτογραφεί το password" do
    user = create(:user, password: "plaintext123")
    expect(user.encrypted_password).not_to eq("plaintext123")
  end
end