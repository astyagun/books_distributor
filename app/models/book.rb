class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_shops
  has_many :shops, through: :book_shops

  validates :title, presence: true
end
