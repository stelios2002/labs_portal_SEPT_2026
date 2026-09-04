class User < ApplicationRecord
  has_one_attached :avatar

  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :posts, dependent: :destroy

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