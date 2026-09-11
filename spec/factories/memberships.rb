FactoryBot.define do
  factory :membership do
    group
    user
    role { "member" }
  end
end