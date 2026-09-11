require "rails_helper"

RSpec.describe Enrollment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:course) }

  it "δεν επιτρέπει διπλή εγγραφή στο ίδιο μάθημα" do
    enrollment = create(:enrollment)
    duplicate = Enrollment.new(user: enrollment.user, course: enrollment.course)
    expect(duplicate).not_to be_valid
  end
end