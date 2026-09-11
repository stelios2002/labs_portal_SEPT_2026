class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :body, presence: true, length: { maximum: 2000 }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    ActionCable.server.broadcast(
      "conversation_#{conversation_id}",
      {
        id: id,
        body: body,
        user_name: user.name,
        user_id: user_id,
        created_at: created_at.strftime("%H:%M")
      }
    )
  end
end