class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_shops, dependent: :destroy
  has_many :shops, through: :book_shops # rubocop:disable Rails/HasManyOrHasOneDependent
end
