class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  validates :code, presence: true, uniqueness: true
  validates :title, presence: true
end