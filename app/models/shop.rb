class Shop < ApplicationRecord
  has_many :shop_books, dependent: :destroy
  has_many :books, through: :shop_books
end
