require "rails_helper"

RSpec.describe Contact, type: :model do
  it { should belong_to(:requester).class_name("User") }
  it { should belong_to(:recipient).class_name("User") }

  it "δεν επιτρέπει αίτημα προς τον εαυτό σου" do
    user = create(:user)
    contact = Contact.new(requester: user, recipient: user)
    expect(contact).not_to be_valid
  end

  it "δεν επιτρέπει διπλό αίτημα" do
    a = create(:user)
    b = create(:user)
    create(:contact, requester: a, recipient: b) rescue Contact.create!(requester: a, recipient: b)
    duplicate = Contact.new(requester: a, recipient: b)
    expect(duplicate).not_to be_valid
  end

  describe "#contacts στο User" do
    it "επιστρέφει μόνο αμοιβαία αποδεκτές επαφές" do
      a = create(:user)
      b = create(:user)
      c = create(:user)
      Contact.create!(requester: a, recipient: b, status: "accepted")
      Contact.create!(requester: a, recipient: c, status: "pending")

      expect(a.contacts).to include(b)
      expect(a.contacts).not_to include(c)
    end
  end
end