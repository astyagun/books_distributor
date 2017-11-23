FactoryBot.define do
  factory :shop_book do
    association :shop
    association :book
    copies_in_stock { rand 999_999 }
    copies_sold     { rand 999_999 }
  end
end
