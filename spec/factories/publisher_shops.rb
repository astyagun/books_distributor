FactoryBot.define do
  factory :publisher_shop do
    association :publisher
    association :shop
    books_sold_count { rand 999_999 }
  end
end
