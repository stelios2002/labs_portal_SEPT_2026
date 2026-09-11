class Conversation < ApplicationRecord
  belongs_to :group, optional: true

  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :messages, dependent: :destroy

  scope :direct, -> { where(group_id: nil) }
  scope :group_chats, -> { where.not(group_id: nil) }

  def self.between(user_a, user_b)
    direct.joins(:conversation_users)
          .where(conversation_users: { user_id: [user_a.id, user_b.id] })
          .group("conversations.id")
          .having("COUNT(DISTINCT conversation_users.user_id) = 2")
          .first
  end
end