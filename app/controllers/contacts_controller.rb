class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = current_user.contacts
    @pending_received = current_user.received_requests.pending.includes(:requester)
    @pending_sent = current_user.sent_requests.pending.includes(:recipient)
  end

  def create
    recipient = User.find(params[:recipient_id])
    contact = current_user.sent_requests.build(recipient: recipient)

    if contact.save
      redirect_to contacts_path, notice: "Το αίτημα στάλθηκε"
    else
      redirect_to contacts_path, alert: contact.errors.full_messages.join(", ")
    end
  end

  def accept
    contact = current_user.received_requests.pending.find(params[:id])
    contact.accepted!
    redirect_to contacts_path, notice: "Η επαφή προστέθηκε"
  end

  def reject
    contact = current_user.received_requests.pending.find(params[:id])
    contact.rejected!
    redirect_to contacts_path, notice: "Το αίτημα απορρίφθηκε"
  end

  def destroy
    contact = Contact.accepted.find_by!(
      "(requester_id = :uid AND recipient_id = :cid) OR (requester_id = :cid AND recipient_id = :uid)",
      uid: current_user.id, cid: params[:id]
    )
    contact.destroy
    redirect_to contacts_path, notice: "Η επαφή αφαιρέθηκε"
  end
end