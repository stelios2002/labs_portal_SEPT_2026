FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 4) }
    body { Faker::Lorem.paragraph }
    user
  end
end