class Book < ApplicationRecord
  belongs_to :publisher
  has_many :shop_books, dependent: :destroy
  has_many :shops, through: :shop_books # rubocop:disable Rails/HasManyOrHasOneDependent
end
