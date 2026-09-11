require "rails_helper"

RSpec.describe "Contacts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  it "δεν επιτρέπει αποδοχή αιτήματος που δεν απευθύνεται στον χρήστη" do
    contact = create(:contact, requester: other_user, recipient: create(:user))
    patch accept_contact_path(contact)
    expect(response).to have_http_status(404)
  end

  it "επιτρέπει αποδοχή δικού του αιτήματος" do
    contact = create(:contact, requester: other_user, recipient: user)
    patch accept_contact_path(contact)
    expect(contact.reload.status).to eq("accepted")
  end
end