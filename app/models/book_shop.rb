class BookShop < ApplicationRecord
  belongs_to :book
  belongs_to :shop

  validates :book, :shop, presence: true
end
