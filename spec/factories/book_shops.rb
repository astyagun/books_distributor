FactoryBot.define do
  factory :book_shop do
    association :book
    association :shop
    copies_in_stock { rand 999_999 }
    copies_sold     { rand 999_999 }
  end
end
