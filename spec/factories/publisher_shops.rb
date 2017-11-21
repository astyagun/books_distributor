FactoryBot.define do
  factory :publisher_shop do
    association :publisher
    association :shop
  end
end
