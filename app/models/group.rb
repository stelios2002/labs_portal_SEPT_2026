class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :conversations, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
end