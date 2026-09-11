class Contact < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :recipient, class_name: "User"

  enum :status, { pending: "pending", accepted: "accepted", rejected: "rejected" }

  validates :requester_id, uniqueness: { scope: :recipient_id }
  validate :cannot_request_self

  private

  def cannot_request_self
    errors.add(:recipient_id, "δεν μπορεί να είναι ο ίδιος χρήστης") if requester_id == recipient_id
  end
end