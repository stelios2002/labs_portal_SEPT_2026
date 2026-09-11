class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum :role, { member: "member", owner: "owner" }

  validates :user_id, uniqueness: { scope: :group_id }
end