FactoryBot.define do
  factory :contact do
    requester factory: :user
    recipient factory: :user
    status { "pending" }
  end
end