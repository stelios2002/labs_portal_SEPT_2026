FactoryBot.define do
  factory :contact do
    requester { nil }
    recipient { nil }
    status { "MyString" }
  end
end
