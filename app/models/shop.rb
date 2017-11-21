class Shop < ApplicationRecord
  has_many :book_shops
  has_many :books, through: :book_shops

  validates :name, presence: true
end
