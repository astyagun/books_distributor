FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    association :publisher
  end
end
