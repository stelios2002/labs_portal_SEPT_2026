class User < ApplicationRecord
  has_one_attached :avatar

  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :posts, dependent: :destroy

  has_many :sent_requests, class_name: "Contact", foreign_key: :requester_id, dependent: :destroy
  has_many :received_requests, class_name: "Contact", foreign_key: :recipient_id, dependent: :destroy


  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :destroy
  
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :messages, dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"

  def contacts
    accepted_sent = User.joins("INNER JOIN contacts ON contacts.recipient_id = users.id")
                        .where(contacts: { requester_id: id, status: "accepted" })
    accepted_received = User.joins("INNER JOIN contacts ON contacts.requester_id = users.id")
                            .where(contacts: { recipient_id: id, status: "accepted" })
    User.where(id: accepted_sent.select(:id)).or(User.where(id: accepted_received.select(:id)))
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  validates :name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end
end