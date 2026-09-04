class Post < ApplicationRecord
  belongs_to :user

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 3, maximum: 150 }
  validates :body, presence: true, length: { maximum: 5000 }

  scope :recent, -> { order(created_at: :desc) }
end