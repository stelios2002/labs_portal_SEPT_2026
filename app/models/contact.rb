class Contact < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :recipient, class_name: "User"

  enum :status, { pending: "pending", accepted: "accepted", rejected: "rejected" }

  validate :cannot_request_self
  validate :no_existing_relationship, on: :create

  private

  def cannot_request_self
    errors.add(:recipient_id, "δεν μπορεί να είναι ο ίδιος χρήστης") if requester_id == recipient_id
  end

  def no_existing_relationship
    return if requester_id.blank? || recipient_id.blank?

    exists = Contact.where(
      "(requester_id = :a AND recipient_id = :b) OR (requester_id = :b AND recipient_id = :a)",
      a: requester_id, b: recipient_id
    ).where.not(status: "rejected").exists?

    errors.add(:base, "Υπάρχει ήδη αίτημα ή επαφή με αυτόν τον χρήστη") if exists
  end
end