FactoryBot.define do
  factory :course do
    sequence(:code) { |n| "CS#{100 + n}" }
    title { Faker::Educator.course_name }
  end
end